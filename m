Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbXFMMCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbXFMMCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 08:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757253AbXFMMCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 08:02:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:60277 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756591AbXFMMCN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 08:02:13 -0400
X-Authenticated: #153925
X-Provags-ID: V01U2FsdGVkX1/vTcpncy7vZQayK0NaUL1Dy18Y5AWsYQJx0D4Ivg
	c0TfIAyKTBrl84
From: Bernd Paysan <bernd.paysan@gmx.de>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Wed, 13 Jun 2007 14:02:10 +0200
User-Agent: KMail/1.9.5
References: <466A3EC6.6030706@netone.net.tr> <20070612184110.GB7980@kroah.com> <orir9smp3u.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <orir9smp3u.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Message-Id: <200706131402.11396.bernd.paysan@gmx.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 June 2007 06:53, Alexandre Oliva wrote:
> You mean all the misunderstandings? ;-)

My impression as well is that there are many misunderstandings, even 
concerning the status of Linux itself. Linus is much better at kernel 
hacking than at license issues, and that's true for most other kernel 
hackers, too - that's why we have Eben Moglen to hack the license.

I want to add my two cents on what I think the legal status of the 
individual contributions to Linux are. The thing in question is not the 
GPLv2 itself (which is pretty clear that code without explicit statements 
is under "any", and if you make an explicit statement, it should read "GPL 
version two, or (at your option) any later version"), it's this text on the 
top of /usr/src/linux/COPYING:

"Also note that the only valid version of the GPL as far as the kernel
 is concerned is _this_ particular version of the license (ie v2, not
 v2.2 or v3.x or whatever), unless explicitly otherwise stated.

                        Linus Torvalds"

This text was added in or around 2.4.0-test9, but without asking for 
permission (neither from the FSF, which has the copyright of the GPL, nor 
from the other authors of the Linux kernel), and with some controversion 
afterwards.

This particular comment to how the GPL is applied to the Linux kernel 
therefore doesn't change the GPL as such (it can't without breaking 
copyright), neither does it change the licensing conditions the original 
authors put on their contribution (it can't without breaking copyright, 
either), but may only provide interpretations downstream (for the user). 
Linus is also entitled to make clairifications there, which the first 
paragraph obviously does (i.e. the text Linus added is not a change of the 
license, but a comment on it).

Again: What Linus is entitled to do is to *select* the license under which 
he redistributes the code downstream. What he can't do is to *change* the 
intention of the original author. So if you can choose what this somewhat 
ambiguous message means, and restrict yourself to reasoning that doesn't go 
into nonsense or copyright infringement, you'll pretty much come to the 
conclusion that the only thing Linus could have done back then without 
asking for permission is the license condition how he *redistributes* the 
compiled work called "Linux kernel" (it's a "compiled work", because it 
consists of a compilation of individual files from many authors).

The GPLv2 however is very clear how the end user gets the license: from the 
original author. Not from the man in the middle, from a distributor or 
kernel maintainer, who can neither add nor drop restrictions/permissions 
(and thus the special rights of a compilation editor are void). The author 
can only speak for himself, not by behalf of somebody else, as well as the 
compilation editor. That's why the FSF is so strict about having each 
author stating copyright and the license conditions on the top of the 
file - nobody else can.

So my conclusion is: If you, as contributor to the Linux kernel, want to 
make clear that your work really is GPLv2 only, you have to do that 
yourself, you have to add a notice like above to files where you 
exclusively own copyright. Very few have done that in the past, most people 
who *did* explicitely declare what versions of the GPL they want their work 
under, did choose the default text from the GPLv2, which sais "GPLv2 or 
later" (most use the GPL text template). The rest (the majority) did not 
choose to say anything, which under the GPL regime means "any"; and nobody 
but the author himself can change that (by adding a specific version). 
Linus can't change the GPL regime, because he can't change the GPL.

So, IMHO and IANAL, technically, there are only a few files in Linux which 
really can't work in a GPLv2+GPLv3 compiled Linux, and a few files wouldn't 
be a problem.

>From a practical point of view, I fully agree with Linus that there's no 
point in switching over to the GPLv3 next month unless there's some 
valueable contribution out there that's only available under GPLv3 (maybe 
from OpenSolaris), or the Linux kernel developers understand the GPLv3 
better. I don't see this point in the near future.

But what I want to say: The route to GPLv3 is not as blocked as it appears. 
And the GPLv2 is even better than you think: It paves that road as well: In 
practice, only projects that have a thight authorship control can really 
make their project GPLv2 only (like MySQL), and those projects have no 
problem to change their mind later.

What I don't understand about the GPLv3 with keys is why that depends on the 
use case. As user of commercial devices like company routers, firewalls and 
such, which often are Linux based, I don't want them sealed by the vendor, 
as well. An explicit statement is even worse than an implicit one (as in 
the GPLv2, which has been tested in a German court by Harald Welte - 
Siemens had to turn in the keys).

And now flame me to death ;-).

-- 
Bernd Paysan
"If you want it done right, you have to do it yourself"
http://www.jwdt.com/~paysan/
