Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbZFDPKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbZFDPKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 11:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZFDPKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 11:10:39 -0400
Received: from thunk.org ([69.25.196.29]:54716 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbZFDPKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 11:10:38 -0400
Date: Thu, 4 Jun 2009 11:10:03 -0400
From: Theodore Tso <tytso@mit.edu>
To: George Dunlap <george.dunlap@eu.citrix.com>
Cc: Frans Pop <elendil@planet.nl>, Bill Davidsen <davidsen@tmr.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "jeremy@goop.org" <jeremy@goop.org>, "mingo@elte.hu" <mingo@elte.hu>,
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
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: Xen is a feature
Message-ID: <20090604151003.GB2542@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	George Dunlap <george.dunlap@eu.citrix.com>,
	Frans Pop <elendil@planet.nl>, Bill Davidsen <davidsen@tmr.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"jeremy@goop.org" <jeremy@goop.org>,
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
	"jens.axboe@oracle.com" <jens.axboe@oracle.com>
References: <4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net> <4A1FCE8E.2060604@eu.citrix.com> <alpine.LFD.2.00.0905311607560.3379@localhost.localdomain> <4A26D3D8.6080002@tmr.com> <alpine.LFD.2.00.0906032204220.3419@localhost.localdomain> <alpine.LFD.2.00.0906032204220.3419@localhost.localdomain> <4A26FB3B.6010205@tmr.com> <200906040129.07852.elendil@planet.nl> <4A27CA44.3060604@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A27CA44.3060604@eu.citrix.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 02:21:08PM +0100, George Dunlap wrote:
> If (hypothetically) we merged Xen into Linux, then (people are  
> suggesting) the coolness of Xen would actually contribute to the  
> coolness of Linux ("add technical benefit to the code base").  People  
> would feel like working on the interface between linux-xen and the rest  
> of linux would be making their own piece of software, Linux, work  
> better, rather than feeling like they have to work with some foreign  
> project that doesn't make their code any cooler.
>
> Is that a pretty accurate representation of the "adding features which  
> have a technical benefit to the code base" argument?

The other argument is that by merging Xen into Linux, it becomes
easier for kernel developers to understand *why* "if (xen) ..." shows
up in random places in core kernel code, and it becomes easier to
clean that up.

If Xen isn't merged, it becomes much harder to believe that those
cleanups will occur, since the Xen developers might stonewall such
cleanups for reasons that Linux developers might not consider valid.
So the threshold for accepting patches might be much higher, since the
subsystem maintainers involved might decide to NAK patches as
uglifying the Linux kernel codebase with no real benefit to the Linux
codebase --- and not much hope that said ugly hacks will get cleaned
up later.  Historically, once code with warts gets merged, we lose all
leverage towards fixing those warts afterwards; this is true in
general, and not a statement of a lack of trust of Xen developers
specifically.

This doesn't make merging Xen *impossible*, but probably makes it
harder, since each of those objections will have to be cleared,
possibly by refactoring the code so that it adds benefits not just for
Xen, but some other in-kernel user of that abstraction (i.e., like
KVM, lguest, etc.) or by cleaning up the code in general, in order to
clear NAK's by the relevant developers.  

If Xen is merged, then ultimately Linus gets to make the call about
whether something gets fixed, even at the cost of making a change to
the hypervisor/dom0 interface.  So this would likely decrease the
threshold of what has to be fixed before people are willing to ACK a
Xen merge, since there's better confidence that these warts will be
cleaned up.  An example of that might be XFS, which had all sorts of
Irix warts which has been gradually cleaned up over the years.  Of
course, there might still be some hideous abstraction violations that
would have to be cleaned up first; but that's up to the relevant
subsystem maintainers.

	       	   		  	     - Ted
