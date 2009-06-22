Return-Path: <linux-kernel-owner+w=401wt.eu-S1757508AbZFVSdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbZFVSdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 14:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbZFVSdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 14:33:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41564 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbZFVSdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 14:33:02 -0400
Date: Mon, 22 Jun 2009 21:32:22 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Gregory Haskins <gregory.haskins@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [KVM PATCH v3 3/3] KVM: Fix races in irqfd using new
	eventfd_kref_get interface
Message-ID: <20090622183222.GF15228@redhat.com>
References: <20090622155504.22967.50532.stgit@dev.haskins.net> <20090622160556.22967.76273.stgit@dev.haskins.net> <20090622165708.GB15228@redhat.com> <4A3FBFF1.8050504@gmail.com> <20090622174506.GD15228@redhat.com> <alpine.DEB.1.10.0906221105500.10952@makko.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0906221105500.10952@makko.or.mcafeemobile.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 11:11:12AM -0700, Davide Libenzi wrote:
> On Mon, 22 Jun 2009, Michael S. Tsirkin wrote:
> 
> > Not really, it's impossible to document all races one have thought
> > about and avoided.
> 
> Well, when some new code has non-trivial locking/racing logics, you better 
> document it as clearly as possible, akpm announced time ago.

Absolutely. But IMO documentation in the form of "fields A B C are
protected by lock X" in a single place near field declaration is better
than "we take lock X here to protect against race with user thread using
fields A B C" sprinkled all over the code.


