Return-Path: <linux-kernel-owner+w=401wt.eu-S1763732AbXF0XIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763732AbXF0XIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 19:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759341AbXF0XIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 19:08:23 -0400
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:58291 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758839AbXF0XIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 19:08:22 -0400
To: linux-kernel@vger.kernel.org
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
References: <MDEHLPKNGKAHNMBLJOLKCEKCEMAC.davids@webmaster.com>
	<or4pl0iz15.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070622013417.GT21478@ftp.linux.org.uk>
	<20070622041949.GA15625@thunk.org>
	<orejk4edfl.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070625132853.GH10008@csclub.uwaterloo.ca>
	<orhcov7qsz.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070626041013.GG24745@delft.aura.cs.cmu.edu>
	<orvedb4433.fsf@oliva.athome.lsd.ic.unicamp.br>
	<ormyyn40o9.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070626162541.GA5464@delft.aura.cs.cmu.edu>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Wed, 27 Jun 2007 20:08:08 -0300
In-Reply-To: <20070626162541.GA5464@delft.aura.cs.cmu.edu> (Jan Harkes's message of "Tue\, 26 Jun 2007 12\:25\:41 -0400")
Message-ID: <or3b0d0zdz.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 26, 2007, Jan Harkes <jaharkes@cs.cmu.edu> wrote:

> GPLv2 section 3.
>     The source code for a work means the preferred form of the work for
>     making modifications to it.

> I believe this states that the source code has to be in the preferred
> form for making modifications and not some other form that sucks rocks.

Yes, but in the scenario I proposed, the source code *is* in the
preferred form for making modifications, it just so happens to be
behind a barrier you cannot trespass.  This is not different from
shipping binaries and sources in a CD inside a locked box that you
can't open.  You've received both, but how is the fact that you can't
reach the source code (or the binaries) a violation of the GPL in this
case?

And, if it's not a violation, what is it that makes the case of
shipping programs in a locked enclosure different from shipping them
in a locked computing device?


As for making modifications, I'd like to take this opportunity to
withdraw, for purposes of interpretation, my earlier agreement that
TiVo permits modification, even though it doesn't permit modification
in place.  I don't see any distinction in US copyright law between
modification in place and modification by creating a separate work.
This distinction makes sense for some cases of modification of
software, but it doesn't make sense for other copyrightable works,
such as sculptures, paintings, drawings, etc.

When you modify a sculpture, you're modifying it in place, and this
requires as much copyright permission as creating a modified copy of
it.  Both count as modification.  And if TiVo creates artificial
obstacles to your modifying the copy of GPLed programs that ships in
its devices, then I believe it counts as a restriction on
modification.  I ought to be entitled to modify any bit in the
executable and expect that to have the same effect as modifying that
bit on that executable on any other computer.  The fact that it stops
working as a result of TiVo's design to prohibit modification, rather
than by any other differences in the computer (e.g., the absence of
the signature checks), just goes to show that there is intent to
impose further restrictions on modification of the software.

Saying that I can modify the sources and build another copy of the
binary and then install that, but then it won't work, but that's fine
because this is not modifying, while true, does not disqualify the
claim that TiVo's design imposes artificial restrictions on my
abilities to modify the copies of the program that I have received.



> And yes, I do realize that you intentionally tried to come up with your
> example to somehow bring tivoization to the source code.

Actually, I first came up with this example long before GPLv3dd3 was
published, and I know there have been changes to the draft in response
to it.

Here are variations of another scenario I proposed back then:

- Tivoizing device ships with tivoized software, regardless of whether
the corresponding sources are accessible to the end user or hidden
inside the box, in a fully-encrypted disk that only that machine can
read.

- The software that ships is feature-limited.  It's just barely enough
to enable the device to connect to the network and download
feature-complete software.

- Network authenticates the device with help of the built-in crypto
device, and device requests feature-complete binaries in encrypted
network sessions.  It's in the fature-complete binaries that the most
valuable improvements made by the tivoizer are, that they don't want
to share with anyone else.  Sources *are* available behind the same
authentication machinery you don't can't get past.  Whether the device
chooses to download them into the encrypted device you can't get to,
to dispose of them right away or even leave them around, or it simply
refrains from downloading the sources because it doesn't need them,
the end result is the same: you've received the sources over the
network, but you can't get to them.

- Updates to the feature-complete software can be delivered over the
same secure channel, and, as a result, derived versions of your
software are distributed to third parties in ways that neither you nor
the recipient can get to the sources.


Here's another variation:

- Vendor distributes device with feature-limited software in the
fully-encrypted disk, with just enough software to download sources
from the network, build the feature-complete software from sources,
and install it.

- Sources are behind network authentication, as above, so although
your device receives them, you can't get to them because they're in
the encrypted disk.


Does it seem to you that GPLv2 blocks any of these means to distribute
your code without granting its users access to the source code?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
