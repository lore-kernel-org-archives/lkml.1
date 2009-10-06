Return-Path: <linux-kernel-owner+w=401wt.eu-S932186AbZJFLWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbZJFLWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 07:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932137AbZJFLWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 07:22:17 -0400
Received: from relay02-haj2.antispameurope.com ([83.246.65.52]:50243 "EHLO
	relay02-haj2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932090AbZJFLWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 07:22:16 -0400
Date: Tue, 06 Oct 2009 13:20:02 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: Valdis.Kletnieks@vt.edu
Cc: shawn.starr@rogers.com, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM][2.6.31.1] - Cannot burn DVDs - PIONEER DVD-RW DVR-111D
Message-ID: <4acb27e2./mXqwZkoPoa4k9Jj%Joerg.Schilling@fokus.fraunhofer.de>
References: <4ac9d477.7gleZfWVJq3++UDn%Joerg.Schilling@fokus.fraunhofer.de>
 <172428.1254779700@turing-police.cc.vt.edu>
 <4aca7014.bWkj1S1Z6N2kt4dr%Joerg.Schilling@fokus.fraunhofer.de>
 <188185.1254800635@turing-police.cc.vt.edu>
In-Reply-To: <188185.1254800635@turing-police.cc.vt.edu>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 06 Oct 2009 11:21:29.0493 (UTC) FILETIME=[26873C50:01CA4677]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:

> On Tue, 06 Oct 2009 00:15:48 +0200, Joerg Schilling said:
> >                                                        The fork did see 
> > some speudo activity in the time between september 2006 and May 6th 2007 but it
> > is dead since then.
>
> http://cdrkit.org/releases/ says differently:
>
> [ ]	cdrkit-1.1.3.tar.gz	26-Mar-2007 20:38 	1.4M
> [ ]	cdrkit-1.1.4.tgz	01-Apr-2007 20:12 	1.4M
> [ ]	cdrkit-1.1.5.1.tar.gz	21-Apr-2007 09:54 	1.3M
> [ ]	cdrkit-1.1.5.tar.gz	21-Apr-2007 09:24 	1.3M
> [ ]	cdrkit-1.1.6.tar.gz	06-May-2007 15:44 	1.3M
> [ ]	cdrkit-1.1.7.1.tar.gz	17-Mar-2008 21:47 	1.4M
> [ ]	cdrkit-1.1.8.tar.gz	25-May-2008 23:02 	1.4M
> [ ]	cdrkit-1.1.9.tar.gz	26-Oct-2008 23:17 	1.4M
>
> Slow-moving maybe, but hardly "dead". 

Even a corpse may slowly move, at the least when maggots are inside ;-)


The fact that you see "new versions" does not prove _project_ _activities_.
Do you like to call single char changes in man pages "project activity"?
In a lazy week, cdrtools change more than cdrkit changed since May 6th 2007.

Since the version that the fork was based on, more than 30% new code and 
features have been added to cdrtools and more than 50% of all code was replaced 
or rewritten in the original project. People who continue to use the fork
contiunue to use software from 2005 with even bugs added. Do you like to
continue to use a Linux kernel from 2005?

Do you like to use software (like cdrkit) where the maintainers just ignore bug 
reports? If you sum up all related bugs from all Linux distributors, you will 
find more than 100 distinct bugs in the fork. None of these bugs (even very 
easy to fix ones) has been fixed since May 6th 2007. This is why I call the fork
"unmaintained". Does this help you to understand my message?


> > The fork is a problem caused by a hostile packetizer, see:
>
> > http://cdrecord.berlios.de/private/linux-dist.html

> Unfortunately, "there are still people who spread incorrect claims" seems to
> include one Joerg Schilling. Please fix your incorrect "28 months" claim, and
> all similar issues.  It will help your original project's credibility.

OK, I fixed this and changed 28 to 30 and reworded a bit...
What other problems do you see?


> It also says:
>
> "In all programs of the fork that send SCSI commands, you may be unable to
> access any of the CD/DVD/Blu-Ray drives at all if you are on Linux-2.6.8.1 or
> later. This is due to a missing workaround for the Linux kernel interface
> change that happened with Linux-2.6.8.1."

This is correct!

There are two problems that have been introduced at the time when Linux-2.6.8.1
did came out.

One was: The SCSI over ATA transport was ripped out off the SCSI subsystem.

The other: The Linux kernel interface did get an incompatible change that 
caused applications (like cdrcord), that conform to the official interface 
descriptions to fail, while it did help applications that did depend on a 
recently introduced Linux kernel security bug. This is a sad fact as the 
applications that depend on the security bug are developed on Linux but as
a result are non-portable to other platforms. 

Note that these programs are mostly GUIs and due to the complexity of GUI 
system libraries, you cannot do complete security audits on GUI programs and
as a result, sysadmins do not like GUIs to be installed suid root. Porting the
related applications to other platforms would force them to be installed suid 
root in order to be able to work :-(

> If this is the SCSI command filtering that was cleared up in 2.6.12, you
> probably owe it to users to point out that little detail.  2.6.12 is over 4
> years ago.  Given that when the fork happened, 2.6.17 was already current, I
> could see why they didn't forward-port the fix for an issue that was only a
> problem then if your kernel was already more than 2 years old, and instead just
> put in doc/plattforms/README.linux:

You may not know that the incompatible interface change in the Linux kernel
has been introduced less than a seek before cdrtools-2.01-final was released.
For this reason, we have been in a code-freeze phase and all I could do at that 
time was to add a message that told the users to downgrade to a Linux kernel
from a time before the incompatible change was introduced.

Sidenote begin ----->
I hope that in future, interface changes in the Linux kernel are avoided. If 
they are needed, they should be announced to the related "consumers" of the
interfaces early anough in order to allow to write a workaround. Note that
many applications and GUIs depend on cdrtools and I tend to announce 
incompatible interface changes 5 years before I implement them.
<----- Sidenote end

Because of a high workload with OpenSolaris activities, I did not find the time
to introduce a _complete_ workaround for the incompatible interface change in 
the Linux kernel before November 12th 2006. I introduced a partial workaround 
in May 2005 (this may have made it into the fork), but the workarounds introduced
on November 12th 2006 finally allowed cdrecord to work again smoothly on recent 
Linux kernels. Note that the latter changes are definitely not inside the fork.

At the same time, I added a new feature into cdrecord/libscg that I call 
"auto-target" mode that allows cdrecord and other SCSI programs that depend on 
libscg to work without dev= parameter for 99% of all users.

>  - Linux kernel versions between 2.6.8 and 2.6.11 are known to have invasive
>    SCSI command filtering which makes the use of wodim almost inpossible or
>    complicated for non-root users. Avoid those kernel versions, unless they
>    have been patched to disable that filtering.

Do you like to tell me that the SCSI filtering does no longer apply to recent 
Linux kernels? From my information, the SCSI filtering is still present and 
requires cdrecord to have root privileges as it was needed for every SCSI 
command during the whole life of Linux before Linux-2.6.8.1 (if you forget 
about the security bug introduced a short time before 2.6.8.1).

> So this claim, although possibly technically correct, is vastly misleading,
> especially 4 years later.

I am not shure, but you may not be informed correctly....

> > You can help: Ask your Linux distributor why he distributes an illegal and 
> > buggy fork instead of the legal original software!
>
> Apparently it's distributed because their legal team doesn't think it's an
> illegal fork, and it's still buggy because after you relicensed to CDDL, they
> felt they couldn't backport your fixes to the original GPL code.

The Linux distributors that distribute the fork need to be repared to be sued
because they distribute software that is in conflict with the Copyright law.
Note that the Copyright law is a higher legal estate than a contract (like the 
GPL) that does not even mention the specific changes that make the fork
unredistributable. As a result, the GPL does not allow you to do changes on 
software in case these changes are in conflict with the Copyright law.

The CDDL is definitely an approved OpenSource License, so the distributors only 
need to upgrade cdrtools to a recent CDDL based version.

BTW: If taken seriously, the incorrect claims made about cdrtools by the hostile 
downstream (that introduced the conflict), would turn the GPL into a definitely 
non-free license as his GPL interpretations are in conflict with the 
OpenSource definition section 9. See the special comment in 
http://www.opensource.org/docs/definition.php for section 9.

If the Linux distributors pay own lawyers, they should know this. The whole 
problem did cause a massive harm to the OpenSource movement in special as it is 
obviously not a legal problem but a social problem.

Hostile downstreams are a real risk for OSS and we the OSS authors need to find a 
way to deal with this problem.

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       joerg.schilling@fokus.fraunhofer.de (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/private/ ftp://ftp.berlios.de/pub/schily
