Return-Path: <linux-kernel-owner+w=401wt.eu-S1759076AbZFBSJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076AbZFBSJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 14:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755552AbZFBSJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 14:09:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755083AbZFBSJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 14:09:12 -0400
Date: Tue, 2 Jun 2009 11:02:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: George Dunlap <george.dunlap@eu.citrix.com>
cc: Thomas Gleixner <tglx@linutronix.de>, David Miller <davem@davemloft.net>,
       "jeremy@goop.org" <jeremy@goop.org>, "mingo@elte.hu" <mingo@elte.hu>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       "avi@redhat.com" <avi@redhat.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
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
In-Reply-To: <alpine.LFD.2.01.0906021033230.3351@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0906021053050.3351@localhost.localdomain>
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default> <20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net> <4A1FCE8E.2060604@eu.citrix.com> <alpine.LFD.2.00.0905311607560.3379@localhost.localdomain>
 <4A25564A.70608@eu.citrix.com> <alpine.LFD.2.01.0906021033230.3351@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Jun 2009, Linus Torvalds wrote:
> 
> I dunno. I just do know that I pointed out the statistics for how 
> mindlessly incestuous the Xen patches have historically been to Jeremy. He 
> admitted it. I've not seen _anybody_ say that things will improve. 

In case people want to look at this on their own, get a git tree, and run 
the examples I asked Jeremy to run:

        git log --pretty=oneline --full-diff --stat arch/x86/kvm/ |
                grep -v '/kvm' |
                less -S

and then go ahead and do the same except with "xen" instead of "kvm".

Now, once you've done that, ask yourself which one is going to be merged 
easily and without any pushback.

Btw, this is NOT meant to be a "xen vs kvm" thing. Before you react to the 
"kvm" part, replace "arch/x86/kvm" above with "drivers/scsi" or something.

The point? Xen really is horribly badly separated out. It gets way more 
incestuous with other systems than it should. It's entirely possible that 
this is very fundamental to both paravirtualization and to hypervisor 
behavior, but it doesn't matter - it just measn that I can well see that 
Xen is a f*cking pain to merge.

So please, Xen people, look at your track record, and look at the issues 
from the standpoint of somebody merging your code, rather than just from 
the standpoint of somebody who whines "I want my code to be merged".

IOW, if you have trouble getting your code merged, ask yourself what _you_ 
are doing wrong.

			Linus
