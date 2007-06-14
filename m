Return-Path: <linux-kernel-owner+w=401wt.eu-S1759478AbXFNCAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478AbXFNCAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 22:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757402AbXFNCAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 22:00:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758948AbXFNCAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 22:00:18 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Bongani Hlope <bhlope@mweb.co.za>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david\@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<200706140215.54179.bhlope@mweb.co.za>
	<or4plbl5gn.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706132108.50030.dhazelton@enter.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Wed, 13 Jun 2007 22:59:49 -0300
In-Reply-To: <200706132108.50030.dhazelton@enter.net> (Daniel Hazelton's message of "Wed\, 13 Jun 2007 21\:08\:49 -0400")
Message-ID: <orlkenjnxm.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 13, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:

> On Wednesday 13 June 2007 20:55:52 Alexandre Oliva wrote:
>> On Jun 13, 2007, Bongani Hlope <bhlope@mweb.co.za> wrote:
>> > On Thursday 14 June 2007 01:49:23 Alexandre Oliva wrote:
>> >> if you distribute copies of such a program, [...]
>> >> you must give the recipients all the rights that you have

>> >> So, TiVo includes a copy of Linux in its DVR.

>> Can they modify the software in their device?

>> Do they pass this right on?

> But this *ISN'T* a right that the GPLv2 *REQUIRES* be passed on. 

You may be right.  The spirit says it should, but the legalese may
have missed the mark.  So GPLv3 makes it clear that it is.

>> It's about that copy of the kernel that ships in the device in object
>> code.  That's the one that TiVo customers ought to be entitled to
>> modify, if TiVo can modify it itself.

> The GPLv2 makes no real provision for *DIRECTLY* modifying object
> code.

Sure.  And that's not what I'm talking about.

What I'm talking about is being able to replace, upgrade, fix, tweak,
hack, and otherwise modify the program on the machine in the same way
that the vendor still can.

> What provisions the GPLv2 has apply to the source code.

This is too narrow a view of the GPLv2 provisions.

> And no, the end user *SHOULD* *NOT* be entitled to run whatever kernel they 
> like on a TiVO. It was designed with the "install new kernel" functionality 
> so that the TiVO corporation could update the kernel running on the hardware 
> when security problems came up, when bugs were fixed or even when the new 
> version gives better performance.

I.e., it was designed such that TiVo could modify the installed
kernel, but the user couldn't.  That's an outright violation of the
spirit of the GPL.

>> > Where does it say you should be able to run you modifications on the
>> > same hardware?

>> Where it says that you should pass on all the rights that you have.

>> While TiVo retains the ability to replace, upgrade, fix, break or make
>> any other change in the GPLed software in the device, it ought to pass
>> it on to its customers.

> It *DOES* *NOT* say "All rights that you have". It says "All rights
> that are granted you by this license".

I suggest you to reboot into memtest ;-)  The preamble of GPLv2 says:

  For example, if you distribute copies of such a program, whether
  gratis or for a fee, you must give the recipients
  all the rights that you have.
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
> If every piece of software released under the GPL had *ALL* rights
> passed on, then *ANYONE* could do the "I'm granting company X the
> right to use this software outside the GPL for $50,000USD."

The requirement above applies to licensees, not to the licensor.  The
licensor doesn't have to pass on all the rights s/he has, s/he only
decides to respect the licensee's freedoms, conditioned to the respect
of others' freedoms by means of passing on all rights the licensee has
over the software.

Arguably, one could use this argument to state that any authors of
derived works ought to pass on the right to choose the license for the
derived work under the GPL, but since (a) the above is not in the
legal terms, and (b) the downstream recipients would be bound by the
terms of the GPL anyway, and that requires the use of the GPL itself,
this would make no difference whatsoever.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
