Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbZE2Apw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbZE2Apw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 20:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbZE2App
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 20:45:45 -0400
Received: from claw.goop.org ([74.207.240.146]:36679 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbZE2Apo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 20:45:44 -0400
Message-ID: <4A1F302E.8030501@goop.org>
Date: Thu, 28 May 2009 17:45:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>, Avi Kivity <avi@redhat.com>,
       George Dunlap <George.Dunlap@eu.citrix.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, "Kurt C. Hackel" <kurt.hackel@oracle.com>,
       Ian Pratt <Ian.Pratt@citrix.com>, xen-users@lists.xensource.com,
       Ky Srinivasan <ksrinivasan@novell.com>,
       Eric Anderson <EAnderson@novell.com>,
       Wim Coekaerts <wimcoekaerts@wimmekes.net>,
       Stephen Spector <stephen.spector@citrix.com>,
       Jens Axboe <jens.axboe@oracle.com>, Nick Piggin <npiggin@suse.de>
Subject: Xen is a feature
References: <4A1C3453.6080402@redhat.com> <162f4c90-6431-4a2a-b337-6d7451d7b11e@default> <20090528001350.GD26820@elte.hu>
In-Reply-To: <20090528001350.GD26820@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Xen changes - especially dom0 - are overwhelmingly not about 
> improving Linux, but about having some special hook and extra 
> treatment in random places - and that's really bad.
>   

You've made this argument a few times now, and I take exception to it.

It seems to be predicated on the idea that Xen has some kind of niche 
usage, with barely more users than Voyager.  Or that it is a parasite 
sitting on the side of Linux, being a pure drain.

Neither is true.  Xen is very widely used.  There are at least 500k 
servers running Xen in commercial user sites (and untold numbers of 
smaller sites and personal users), running millions of virtual guest 
domains.  If you browse the net at all widely, you're likely to be using 
a Xen-based server; all of Amazon runs on Xen, for example.  Mozilla and 
Debian are hosted on Xen systems.

Hardware vendors like Dell and HP are shipping servers with Xen built 
into the firmware, and increasingly, desktops and laptops.  Many laptop 
"instant-on/instant-access" features are based on a combination of Xen 
and Linux.

All major Linux distributions support running as a Xen guest, and many 
support running as a Xen host.

For these users, Xen support is an active feature of Linux; Linux 
without Xen support would be much less useful to them, and better Xen 
support would be more useful.  For them, Xen support is no different 
from any other kind of platform support.  They are being actively 
hampered by the fact that the only dom0 support is available in the form 
of either ancient or very patched kernels. 

To them, improved Xen support *is* "improving Linux".

Your view appears to be that virtualization is either useless, or a neat 
trick useful for doing a quick kernel test (which is why kvm got early 
traction in this community; it is well suited to this use-case).  But 
that is a very parochial kernel-dev view.  For many users, 
virtualization (in general, but commonly on Xen) has become an 
absolutely essential part of their computing infrastructure, and they 
would no more go without it than they would go without ethernet.

We're taking your technical critiques very seriously, of course, and I 
appreciate any constructive comment.  But your baseline position of 
animosity towards Xen is unreasonable, unfair and unnecessary.

    J
