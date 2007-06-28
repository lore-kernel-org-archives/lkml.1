Return-Path: <linux-kernel-owner+w=401wt.eu-S1764495AbXF1G66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764495AbXF1G66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 02:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760336AbXF1G6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 02:58:50 -0400
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:44501 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760365AbXF1G6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 02:58:49 -0400
To: linux-kernel@vger.kernel.org
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
References: <20070622013417.GT21478@ftp.linux.org.uk>
	<20070622041949.GA15625@thunk.org>
	<orejk4edfl.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070625132853.GH10008@csclub.uwaterloo.ca>
	<orhcov7qsz.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070626041013.GG24745@delft.aura.cs.cmu.edu>
	<orvedb4433.fsf@oliva.athome.lsd.ic.unicamp.br>
	<ormyyn40o9.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070626162541.GA5464@delft.aura.cs.cmu.edu>
	<or3b0d0zdz.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070628050852.GA16686@delft.aura.cs.cmu.edu>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Thu, 28 Jun 2007 03:58:35 -0300
In-Reply-To: <20070628050852.GA16686@delft.aura.cs.cmu.edu> (Jan Harkes's message of "Thu\, 28 Jun 2007 01\:08\:52 -0400")
Message-ID: <orodj0y38k.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 28, 2007, Jan Harkes <jaharkes@cs.cmu.edu> wrote:

>> As for making modifications, I'd like to take this opportunity to
>> withdraw, for purposes of interpretation, my earlier agreement that
>> TiVo permits modification, even though it doesn't permit modification
>> in place.  I don't see any distinction in US copyright law between
>> modification in place and modification by creating a separate work.

> In section 2 where it talks about modifications it at first doesn't seem
> to distinguish between source and binary, but it doesn't grant the right
> that the resulting modified program will actually work. And yes, you can
> still modify the kernel binary on the Tivo harddrive, it just won't boot
> with the standard bootloader.

> But there is an explicit no warranty clause in the GPLv2. Which I
> believe is a good thing. If the license tried to enforce usability,

Yup.  But will courts see this as a valid excuse for effectively
denying users the ability to modify the copies of the GPLed programs
they run on tivoized devices, even though the means to accomplish this
are based on blocking the ability to run the modified executable,
which happens to not require permission from the copyright holder in
the US?

Even more so when the modified binary provably works just fine on
similar computers, and fails to work on the tivoizing device just
because mechanisms were introduced to stop the user from modifying the
behavior of the software that runs in the device?  I.e., it fails
because you changed it, rather than because you broke it.

Couldn't this be understood by a court as an attempt to exploit a
loophole in the letter of the license, rather than as an intentional
permission to restrict the ability to run covered programs, an act
that the license phrases as "not restricted" and "outside its scope"
just because US copyright law doesn't demand permission from the
copyright holder to run programs, which results in permission to run
being outside the scope of a copyright license?


Anyhow, I didn't mean to restart this debate, I just wanted (as stated
above) to withdraw my earlier tentative agreement that "modification
in place" was something that could be forbidden without infringing
GPL.

>> When you modify a sculpture, you're modifying it in place, and this
>> requires as much copyright permission as creating a modified copy of
>> it.  Both count as modification.

> And when you scribble in the margin of a book you are also modifying it,
> so what.

Maybe it's fair use, especially for a printed book, of which many
copies presumably exist.

> I don't think you even need copyright permission, although you
> will probably get into trouble if the book was borrowed from a library.
> I don't see the relevance in the context of this discussion.

Relevance was only to counter the argument that the right to "modify
in place", as some put it, was not covered by the GPL, "because that's
not how copyright law defines modification."  I bought that argument
at first, but then I referred back to US copyright law and not only
failed to find supporting evidence for this argument, but actually
found opposing evidence.  So I brought it up to make sure my tentative
agreement wouldn't be used in a court as an indication that the
argument holds water.

>> Here are variations of another scenario I proposed back then:
>> 
>> - Tivoizing device ships with tivoized software, regardless of whether
>> the corresponding sources are accessible to the end user or hidden
>> inside the box, in a fully-encrypted disk that only that machine can
>> read.

> I'm assuming no written offer for access to the software is included.

Yup, that's the idea.

> Source are inaccessible, restricted the recipients rights to copy,
> distribute and modify the source code, GPLv2 violation.

So, the same standards would apply to the binaries: if they were
inaccessible, copyright holder could claim infringement under the same
grounds, right?

> If it doesn't download the sources then the binary is not accompanied by
> the corresponding source code and since we assumed no written offer this
> is a violation of section 3.

Except, perhaps, for this bit:

  If distribution of executable or object code is made by offering
  access to copy from a designated place, then offering equivalent
  access to copy the source code from the same place counts as
  distribution of the source code, even though third parties are not
  compelled to copy the source along with the object code.

So, let's narrow the scenario to: tivoized machine downloads binary
from protected site, refrains from downloading sources that it could
download, user can still access and copy the binaries, but can't
obtain the sources because the machine opted not to get them.

Now, the user can't distribute the binaries, because doing so without
being able to get the sources to pass them on would be copyright
infringement.  Would a court see this as a restriction on distribution
imposed by the distributor?  Or by the copyright holder?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
