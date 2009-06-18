Return-Path: <linux-kernel-owner+w=401wt.eu-S1758985AbZFRGXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758985AbZFRGXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 02:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbZFRGX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 02:23:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41289 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbZFRGX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 02:23:29 -0400
Date: Thu, 18 Jun 2009 09:23:01 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based
	notifier interface
Message-ID: <20090618062301.GA11155@redhat.com>
References: <4A37C592.2030407@novell.com> <alpine.DEB.1.10.0906160915340.25664@makko.or.mcafeemobile.com> <4A37CFDA.4000602@novell.com> <alpine.DEB.1.10.0906170932290.7891@makko.or.mcafeemobile.com> <4A3927C0.5060607@novell.com> <alpine.DEB.1.10.0906171034030.7891@makko.or.mcafeemobile.com> <4A39415C.9060803@novell.com> <alpine.DEB.1.10.0906171247120.7891@makko.or.mcafeemobile.com> <4A39649C.4020602@novell.com> <alpine.DEB.1.10.0906171457000.7891@makko.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0906171457000.7891@makko.or.mcafeemobile.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 04:21:19PM -0700, Davide Libenzi wrote:
> The interface is just ugly IMO. You have eventfd_signal() that can sleep, 
> or not, depending on the registered ->signal() function implementations.
> This is pretty bad, a lot worse than the theoretical us spent in the 
> schedule_work() processing.

I agree. How about the idea of introducing eventfd_signal_from_task
which can sleep? Does this sound same?

-- 
MST
