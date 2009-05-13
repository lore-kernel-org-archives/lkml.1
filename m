Return-Path: <linux-kernel-owner+w=401wt.eu-S1753134AbZEMBwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbZEMBwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 21:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbZEMBwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 21:52:04 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:62587 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbZEMBwD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 21:52:03 -0400
MIME-Version: 1.0
In-Reply-To: <49f07fa8.UFHStOXJD5eYq3ER%Joerg.Schilling@fokus.fraunhofer.de>
References: <49f07fa8.UFHStOXJD5eYq3ER%Joerg.Schilling@fokus.fraunhofer.de>
Date: Tue, 12 May 2009 21:52:00 -0400
Message-ID: <f73f7ab80905121852y42b200a4rfa25ed2b76dd3754@mail.gmail.com>
Subject: Re: [2.6.30-rc2] CD-R: wodim intermittent failures: [sr0] Add. Sense: 
	Logical block address out of range, sector 0
From: Kyle Moffett <kyle@moffetthome.net>
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
Cc: adi@hexapodia.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 10:48 AM, Joerg Schilling
<Joerg.Schilling@fokus.fraunhofer.de> wrote:
> I see two possible problems that should be first resolved.
>
> 1)      You are using "wodim" instead of cdrecord.
>        "wodim" is a very old version (4+ years) of cdrecord with
>        additional bugs. Due to Copyright & GPL violations, it cannot
>        even be legally distributed.

Not to get into a flamewar on this, but multiple sources disagree with
you on this point.  Just so it is clear... I do not expect a reply to
this message and I will not read one if it is sent.  I simply wish to
exercise my free speech rights and provide potentially useful
information.

Since you released cdrtools under the GPL, you cannot possibly expect
to claim that someone else distributing a copy under the same license
is violating your copyright.  You also cannot claim trademark
violations as the maintainers of "wodim" intentionally changed the
names of all of the programs.  Debian-based systems no longer even
install the "compatibility symlinks" that you claim to have a problem
with, and have not for some time.  Furthermore, you have certainly
never held a patent on the cdrecord design.

References:
http://lwn.net/Articles/195167/
http://en.wikipedia.org/wiki/Cdrkit
http://www.cdrkit.org/

If you would like to contest specifics of GPL compliance, please also
reference a rather extensive body of other GPL work (incl. the Linux
kernel) which does *NOT* require the following (this list partially
taken from your webpage at
http://cdrecord.berlios.de/new/private/linux-dist.html):

  *  Tracking the author and date for every individual change in every
file.  If this was true, the Linux kernel source (for example) would
be roughly 95% changelogs.

  *  Displaying the copyright messages exactly the same way the
original author does.  The GPL requires that you must preserve the
contents of the copyrights and attribution and make them easily
accessible to the user.

  *  Including source code beyond what was used to produce a specific
binary version.  If I delete code for specific kernel modules from a
kernel tarball and distribute the resulting kernel binary I am legally
*required* to distribute the modified sources (as opposed to the
original sources).

I cannot comment on German legal code as I am neither fluent in German
nor well-versed in that particular legal code.  On the other hand, I
can state that neither of the restrictions you specify apply to
distribution of GPLed binaries within the US.  This is especially true
as the GPL contains the statement that "this software comes without
any warranty whatsoever".

It would be very difficult for someone to prove tangible harm to
reputation from software distributed by a third party under the
original author's terms of "no warranty whatsoever, not even including
the implied warranties of merchantability or fitness for a particular
purpose".


And back to something vaguely resembling the original topic:
> As Linux requires root privileges for many SCSI commands, you need to
> install cdreord suid root which is automatically done via "make install"
> as root.

If you discover that you need root privileges to burn a CD or DVD,
that is a kernel bug and we would very much appreciate a bugreport.

Cheers,
Kyle Moffett
