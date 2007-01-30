Return-Path: <linux-kernel-owner+w=401wt.eu-S1751732AbXA3WS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbXA3WS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:18:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbXA3WS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:18:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40704 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbXA3WS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:18:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: [PATCH 5/5] KVM: Host suspend/resume support
Date: Tue, 30 Jan 2007 23:19:07 +0100
User-Agent: KMail/1.9.1
Cc: Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45BF5B96.1070007@qumranet.com> <20070130145717.00D1BA0014@il.qumranet.com> <1170192049.4308.16.camel@nigel.suspend2.net>
In-Reply-To: <1170192049.4308.16.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701302319.10369.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 30 January 2007 22:20, Nigel Cunningham wrote:
> Hi.
> 
> On Tue, 2007-01-30 at 14:57 +0000, Avi Kivity wrote:
> > Add the necessary callbacks to suspend and resume a host running kvm.  This
> > is just a repeat of the cpu hotplug/unplug work.
> > 
> > Signed-off-by: Avi Kivity <avi@qumranet.com>
> 
> Maybe it's just a lack of understanding, but I'm wondering if this patch
> is necessary - we already hot-unplug secondary cpus prior to suspending
> devices.

Not with the reoredering patches that are in -mm, though.  With these patches,
the nonboot CPUs are disabled after "regular" devices.

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King
