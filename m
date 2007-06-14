Return-Path: <linux-kernel-owner+w=401wt.eu-S1757663AbXFNWPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663AbXFNWPU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754514AbXFNWJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:09:31 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:35222
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbXFNWJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:09:29 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: davids@webmaster.com
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 14 Jun 2007 18:09:28 -0400
User-Agent: KMail/1.9.6
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
References: <MDEHLPKNGKAHNMBLJOLKEEFCEJAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKEEFCEJAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706141809.28682.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 June 2007 15:28:34 David Schwartz wrote:
> > The GPL applies to "the Program" which in this case is the Linux kernel
> > as a whole and it in fact does indicate a specific version. All code
> > submitted and included in this program has has been submitted with the
> > understanding that the work as a whole is specifically licensed as
> > GPLv2. Some authors have granted additional rights, such as dual BSD/GPL
> > or GPLv2 and later and explicitly added such a notice.
>
> Since the Linux kernel as a whole does not have a single author, it is
> impossible to license it as a whole. Nobody has the authority to do that.
> (The GPL is not a copyright assignment type license.)

Actually, Linus Torvalds, as maintainer, probably has a compilation copyright.  
See "compilations and abridgements" in 
http://www.copyright.gov/circs/circ14.html

> Fortunately, the GPL clears this up:
>
> "Each time you redistribute the Program (or any work based on the
> Program), the recipient automatically receives a license from the
> original licensor to copy, distribute or modify the Program subject to
> these terms and conditions.  You may not impose any further
> restrictions on the recipients' exercise of the rights granted herein.
> You are not responsible for enforcing compliance by third parties to
> this License."
>
> Linus cannot impose any further restrictions on the recipients' exercise of
> the rights granted.

If you combine dual licensed code (such as MPL + GPL) with code under only one 
of those licenses (MPL only), the resulting derived work cannot be 
distributed under the dual license, only under one license.  The giant 
derived work knows as Linux has only been distributable under exactly one 
license (GPLv2, the complete text of which is included in the source tarball 
and it's harder to be more explicit than that about which license you mean) 
since version 0.12.

By the way, this entire "oh no, we can use it GPLv3 no matter what you say" 
line of argument is rude.  Linus and most of his lieutenants have explicitly 
said "our contributions are GPLv2 only".  Linus said this explicitly seven 
years ago:
http://www.uwsg.iu.edu/hypermail/linux/kernel/0009.1/0096.html

He confirmed and elaborated his position when people first started pestering 
about v3:
http://lwn.net/Articles/169825/

In James Bottomley's position paper last year, a number of prominent kernel 
developers stated their objection and that their contributions were GPLv2 
only:
  http://lkml.org/lkml/2006/9/22/217

  James E.J. Bottomley             Mauro Carvalho Chehab
  Thomas Gleixner            Christoph Hellwig           Dave Jones
  Greg Kroah-Hartman              Tony Luck           Andrew Morton
  Trond Myklebust             David Woodhouse

Let me translate this into simpler terms:

<lolcats>
GPLv3: Does not want!
</lolcats>

The _reason_ it's rude to go on about it is that several people have chosen to 
see this entire debate as an interesting intellectual exercise, "how much 
code could a GPLv3 licensed project lift from the Linux kernel".   Yet if you 
substitute "BSD Licensed" in there, it's easy to recognize how obnoxious the 
pestering is, despite much of the code in Linux having come from BSD sources.

You don't take Linux kernel code and stick it into a BSD project, even though 
some of it was BSD originally, because Linux (every line of it) is GPLv2.  If 
you want the code under a different license, you go to a differently licensed 
upstream source, such as the original author or the project we adapted it 
from.  If you're not to lift code from Linux to BSD license it, lifting code 
from Linux to GPLv3 it is morally and legally no different.

Linus made his decision, most of his lieutenants explicitly confirmed that 
decision.  Please admit to yourselves that you're arguing that they should 
all change their minds because you don't like their decision, not because 
they didn't have the right to make it or that there's some loophole that 
invalidates it.  What's your argument here, developers who are now 
saying "GPLv2" _accidentally_ gave permission to distribute their code under 
other licenses?  Go ahead and take that to court buddy: you will lose.

If you want to create a GPLv3 fork and can trace back specific files to 
authors who are ok with GPLv3, go create your fork.  If you want to go work 
on Solaris, go do that.  (But if you want to transplant Linux code into that 
thing, talk to Sun's lawyers first.  And IBM's, and Red Hat's, and...)

If you want each and every Linux developer who has ever stated a GPLv2 only 
position to either publicly reverse said position or to be ejected from the 
project and their code tracked down and removed from the kernel via forensic 
analysis (which is the only way the Linux kernel itself could ever go GPLv3), 
then do us a favor and shut up.

> When you download a copy of the Linux kernel, you do not receive one
> license because nobody could grant you one license.

Yes you do, you receive GPLv2.  It's in the file "LICENSE" at the top level of 
the directory.  This is the one and only license you receive.

You receive this one license applied to multiple copyrights, but if you're 
confusing a copyright with a license I can't help you. 

> You receive a logically 
> separate license from each original licensor. You receive from Linus only a
> license to his contributions.

A) Look up "compilation copyright".

B) The whole point of the GPL is that the license applies to the entire 
derived work, as a whole.  You can either distribute the whole thing under 
the GPL, or you cannot distribute period.  Therefore, you're saying you can 
take code that was distributed to you under GPLv2 (and only GPLv2), and 
redistribute it under another set of license terms.  In the name of GPLv3, 
you're trying to weasel around GPLv2.  Congratulations, you have achieved 
hypocrisy.

Rob
