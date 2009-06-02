Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbZFBXtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbZFBXtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 19:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbZFBXtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 19:49:04 -0400
Received: from www.tglx.de ([62.245.132.106]:37823 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbZFBXtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 19:49:03 -0400
Date: Wed, 3 Jun 2009 01:41:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: George Dunlap <george.dunlap@eu.citrix.com>,
       David Miller <davem@davemloft.net>, "jeremy@goop.org" <jeremy@goop.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       "avi@redhat.com" <avi@redhat.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       "xen-users@lists.xensource.com" <xen-users@lists.xensource.com>,
       ksrinivasan <ksrinivasan@novell.com>,
       "EAnderson@novell.com" <EAnderson@novell.com>,
       "wimcoekaerts@wimmekes.net" <wimcoekaerts@wimmekes.net>,
       Stephen Spector <stephen.spector@citrix.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "npiggin@suse.de" <npiggin@suse.de>
Subject: Re: Xen is a feature
In-Reply-To: <20090602224051.GB32428@goodmis.org>
Message-ID: <alpine.LFD.2.00.0906030055500.3419@localhost.localdomain>
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default> <20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net> <4A1FCE8E.2060604@eu.citrix.com> <20090602224051.GB32428@goodmis.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jun 2009, Steven Rostedt wrote:
> If we were to break an interface with Dom0 for Xen then we would have a bunch
> of people crying foul about us breaking a defined API. One of Thomas's complaints
> (and a valid one) is that once Linux supports an external API it must always
> keep it compatible. This will hamper new development in Linux if the APIs are
> scattered throughout the kernel without much thought.
> 
> Now here's a crazy solution. Merge the Xen hypervisor into Linux ;-)

Not that crazy as you might think.
 
> Give full ownership of Xen to the Linux community. One of your people could be
> a maintainer. This way the API between Dom0 and the hypervisor would be an internal

s/API/ABI/ :) 

> one. If you needed to upgrade Dom0, you also must upgrade the hypervisor, but that
> would be fine since the hypervisor would also be in the Kernel proper.
> 
> This may not solve all the issues that the x86 maintainers have with the Dom0
> patches, but it may help solve the API one.

In fact it would resolve the ABI problem once and forever as we could
fix hypervisor / dom0 in sync. hypervisor and dom0 need to run in
lock-step anyway if you want to make useful progress aside of
maintaining versioned interfaces which are known to bloat rapidly.

It's not a big deal to set a flag day which says: update hypervisor
and (dom0) kernel in one go.

Thanks,

	tglx
