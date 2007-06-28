Return-Path: <linux-kernel-owner+w=401wt.eu-S1760912AbXF1FJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760912AbXF1FJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 01:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbXF1FJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 01:09:00 -0400
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.206.88]:43187 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbXF1FIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 01:08:53 -0400
Date: Thu, 28 Jun 2007 01:08:52 -0400
To: linux-kernel@vger.kernel.org
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
Message-ID: <20070628050852.GA16686@delft.aura.cs.cmu.edu>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20070622013417.GT21478@ftp.linux.org.uk> <20070622041949.GA15625@thunk.org> <orejk4edfl.fsf@oliva.athome.lsd.ic.unicamp.br> <20070625132853.GH10008@csclub.uwaterloo.ca> <orhcov7qsz.fsf@oliva.athome.lsd.ic.unicamp.br> <20070626041013.GG24745@delft.aura.cs.cmu.edu> <orvedb4433.fsf@oliva.athome.lsd.ic.unicamp.br> <ormyyn40o9.fsf@oliva.athome.lsd.ic.unicamp.br> <20070626162541.GA5464@delft.aura.cs.cmu.edu> <or3b0d0zdz.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <or3b0d0zdz.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Jan Harkes <jaharkes@cs.cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 08:08:08PM -0300, Alexandre Oliva wrote:
> On Jun 26, 2007, Jan Harkes <jaharkes@cs.cmu.edu> wrote:
> 
> > GPLv2 section 3.
> >     The source code for a work means the preferred form of the work for
> >     making modifications to it.
> 
> > I believe this states that the source code has to be in the preferred
> > form for making modifications and not some other form that sucks rocks.
> 
> Yes, but in the scenario I proposed, the source code *is* in the
> preferred form for making modifications, it just so happens to be
> behind a barrier you cannot trespass.  This is not different from
> shipping binaries and sources in a CD inside a locked box that you
> can't open.  You've received both, but how is the fact that you can't
> reach the source code (or the binaries) a violation of the GPL in this
> case?

That was explained in next paragraph where I said that preventing access
sure sounds like a restriction on copying and modification, which is
where the GPL violation would be.

> As for making modifications, I'd like to take this opportunity to
> withdraw, for purposes of interpretation, my earlier agreement that
> TiVo permits modification, even though it doesn't permit modification
> in place.  I don't see any distinction in US copyright law between
> modification in place and modification by creating a separate work.

That doesn't really matter because the GPLv2 makes a distinction between
source code and binary object code. For instance in section 1 where it
says that you may copy and distribute the program's source code.

In section 2 where it talks about modifications it at first doesn't seem
to distinguish between source and binary, but it doesn't grant the right
that the resulting modified program will actually work. And yes, you can
still modify the kernel binary on the Tivo harddrive, it just won't boot
with the standard bootloader.

But there is an explicit no warranty clause in the GPLv2. Which I
believe is a good thing. If the license tried to enforce usability, i.e.
"continued functioning of the modified object code is in no case
prevented or interfered with", then any time a new release of the
program causes a regression for some users this would be a license
violation.

> This distinction makes sense for some cases of modification of
> software, but it doesn't make sense for other copyrightable works,
> such as sculptures, paintings, drawings, etc.
> 
> When you modify a sculpture, you're modifying it in place, and this
> requires as much copyright permission as creating a modified copy of
> it.  Both count as modification.

And when you scribble in the margin of a book you are also modifying it,
so what. I don't think you even need copyright permission, although you
will probably get into trouble if the book was borrowed from a library.
I don't see the relevance in the context of this discussion.

>                                   And if TiVo creates artificial
> obstacles to your modifying the copy of GPLed programs that ships in
> its devices, then I believe it counts as a restriction on
> modification.

You can modify the source, recompile it, even binary patch the kernel on
the Tivo's harddrive. None of that is restricted. What is restricted is
the freedom to run the modified object code on Tivo's hardware. That
right is not granted by the GPLv2, and fitness for any purpose is
explicitly disclaimed in the NO WARRANTY section.

... skipped a whole bunch, you actually repeated yourself a couple of
times but the same answer applied, GPLv2 does not grant the right to be
able to run the (modified) program on their hardware, and none of the
granted rights, to copy, distribute and modify, are restricted ...

> Here are variations of another scenario I proposed back then:
>
> - Tivoizing device ships with tivoized software, regardless of whether
> the corresponding sources are accessible to the end user or hidden
> inside the box, in a fully-encrypted disk that only that machine can
> read.

I'm assuming no written offer for access to the software is included.

Source are inaccessible, restricted the recipients rights to copy,
distribute and modify the source code, GPLv2 violation.

otherwise, source is accessible and recipient can copy, distribute and
modify.

> - Network authenticates the device with help of the built-in crypto
> device, and device requests feature-complete binaries in encrypted
> network sessions.  It's in the fature-complete binaries that the most
> valuable improvements made by the tivoizer are, that they don't want
> to share with anyone else.  Sources *are* available behind the same
> authentication machinery you don't can't get past.  Whether the device
> chooses to download them into the encrypted device you can't get to ,
> to dispose of them right away or even leave them around, or it simply
> refrains from downloading the sources because it doesn't need them,
> the end result is the same: you've received the sources over the
> network, but you can't get to them.

If it doesn't download the sources then the binary is not accompanied by
the corresponding source code and since we assumed no written offer this
is a violation of section 3.

If it does download the source code but stores them into an encrypted
device or discards them then the user is restricted in his rights to
copy, distribute or modify the source code, and we have a violation of
section 6.

> Here's another variation:

Sigh, same problem, same solution.

> Does it seem to you that GPLv2 blocks any of these means to distribute
> your code without granting its users access to the source code?

Yes, section 6 doesn't allow blocking access to the source code as it
restricts the recipients rights to copy, distribute and modify that
source code, so we have a license violation and the vendor has no right
to modify or distribute the program or any work based on the program.

Jan
