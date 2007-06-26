Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbXFZGeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbXFZGeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 02:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbXFZGeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 02:34:08 -0400
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:56360 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750880AbXFZGeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 02:34:06 -0400
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
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Tue, 26 Jun 2007 03:33:52 -0300
In-Reply-To: <20070626041013.GG24745@delft.aura.cs.cmu.edu> (Jan Harkes's message of "Tue\, 26 Jun 2007 00\:10\:13 -0400")
Message-ID: <orvedb4433.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 26, 2007, Jan Harkes <jaharkes@cs.cmu.edu> wrote:

> On Mon, Jun 25, 2007 at 04:54:52PM -0300, Alexandre Oliva wrote:
>> Consider this scenario: vendor tivoizes Linux in the device, and
>> includes the corresponding sources only in a partition that is
>> theoretically accessible using the shipped kernel, but that nothing in
>> the software available in the machine will let you get to.  Further,
>> sources (like everything else on disk) are encrypted, and you can only

> Interesting scenario, it seems to comply with GPLv2 on the surface.

> If that kernel doesn't actually allow access and wipes the source
> partition to use it as swap on first boot, then no machine is actually
> capable of reading the source.

Granted, that was just adding insult to the injury ;-)

Assume the sources are kept in the encrypted disk.  Or that the
sources are shipped in an encrypted CD, that only the machine itself
can read, using hardware-assisted decryption.

> Another gripe is that encrypted media are not customarily used for
> software interchange.

That the whole disk is encrypted is "just a technical detail".  And
it's not the media that's encrypted, it's the data in it.  Surely both
hard disks and CDs are media customarily used for software
interchange.  And there is often compressed and encrypted data and
software in them.

> You also cannot interpret the encrypted partition as source code because
> a bit further down in section 3, it defines source code as,
>   "The source code for a work means the preferred form of the work for
>   making modifications to it."

The encrypted partition is not the source code.  It contains the
source code.  Very much like the computer, or the disk, or the boot
partition, is not the GPLed program, it contains the GPLed program.
That it's encrypted, signed, or hardware-protected, have all been
claimed as reasons why they're outside the scope of the GPL and can be
used to escape its intent in this or other recent threads.

> You could argue that they do not restrict copying, distribution
> and modification of the sources in general, only of the specific copy
> they distribute.

"We don't oppose that you do any of these things, once you get the
source code.  We just make it difficult (hopefully impossible) that
you'll get to the source code in the first place."

> They get sued for copyright infringement because they are not in
> compliance with section 3 and the sources are released as a result.

I don't think a copyright lawsuit can be generally expected to obtain
this result.  A court can stop the distributor from distributing in an
infringing manner, but I don't think a court could force the
distributing party to shell out source code.  The distributing party
might not even *have* source code in the first place.  And even if she
had, she might have no right to distribute it.  Or she might not want
to, and then a court *might* require them to do so, but that would be
quite unusual.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
