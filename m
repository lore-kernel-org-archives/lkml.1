Return-Path: <linux-kernel-owner+w=401wt.eu-S965410AbXCFRyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965410AbXCFRyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 12:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965415AbXCFRyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 12:54:16 -0500
Received: from fmmailgate09.web.de ([217.72.192.184]:50172 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965410AbXCFRyQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 12:54:16 -0500
Date: Tue, 06 Mar 2007 18:54:13 +0100
Message-Id: <1667859354@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Lee Revell <rlrevell@joe-job.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, pavel@ucw.cz
Subject: =?iso-8859-15?Q?Re:_[RFC]_BadRAM_still_not_ready_for_inclusion_=3F_(wa?=
 =?iso-8859-15?Q?s:_Re:_Free_Linux_Driver_Development!)?=
Organization: http://freemail.web.de/
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>What's so hard about submitting a 200 line patch to LKML?

that's what i was wondering about ;D
it's not the first time, that i see nice features not being submitted to lkml.

anyway - pavel (thanks btw!) just pointed me to some param "mem=exactmap" :

>I think functionality is there in latest vanila with mem=exactmap even
>w/o patches.

so, maybe we need to find out _if_ and _how_ this could make BadRAM obsolete (i.e. if this is a good alternative) ?
(so we won't need to discuss about BadRAM inclusion anymore. :)

what i found is:

894         memmap=exactmap [KNL,IA-32,X86_64] Enable setting of an exact
895                         E820 memory map, as specified by the user.
896                         Such memmap=exactmap lines can be constructed based on
897                         BIOS output or other requirements. See the memmap=nn@ss
898                         option description.
899 
900         memmap=nn[KMG]@ss[KMG]
901                         [KNL] Force usage of a specific region of memory
902                         Region of memory to be used, from ss to ss+nn.
903 
904         memmap=nn[KMG]#ss[KMG]
905                         [KNL,ACPI] Mark specific memory as ACPI data.
906                         Region of memory to be used, from ss to ss+nn.
907 
908         memmap=nn[KMG]$ss[KMG]
909                         [KNL,ACPI] Mark specific memory as reserved.
910                         Region of memory to be used, from ss to ss+nn.

this indeed looks like something being able to replace BadRAM, but the question is, how to handle/enable that and how to translate BadRAM patterns from memtest86 to be usable. (i.e.: writing a HowTo for the average user not being a kernel wizard)

regards
roland


> -----Ursprüngliche Nachricht-----
> Von: "Lee Revell" <rlrevell@joe-job.com>
> Gesendet: 06.03.07 18:29:58
> An: "devzero@web.de" <devzero@web.de>
> CC: linux-kernel@vger.kernel.org, greg@kroah.com, pavel@suse.cz
> Betreff: Re: [RFC] BadRAM still not ready for inclusion ? (was: Re: Free Linux Driver Development!)


> On 3/4/07, devzero@web.de <devzero@web.de> wrote:
> > It seems, that BadRAM is not being maintained very actively and the original author doesn`t seem to have the time pushing it into mainline, but i know it's actively being used by more then just a handful of people. Unfortunately there is no mailinglist to approve this and some "central point of communication" besides Rick van Rein doesn't seem to exist. There is a fork named BadMEM at http://sourceforge.net/projects/badmem, Memtest86 also supporting BadRAM and i have seen LOTs of discussion about BadRAM on the net. Most of that discussion was due to problems getting it run with Kernel XYZ.
> >
> > Basically, this feature is a matter of adding/modifying 200 lines of code, so iŽm even more wondering, why it exists for more than 7 years and nothing happening here.
> 
> Because most kernel developers don't have time to scour the net for
> random kernel patches and pull them.  If you have a useful patch you
> want merged it's up to you to push it.
> 
> What's so hard about submitting a 200 line patch to LKML?
> 
> Lee
> 


_____________________________________________________________________
Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
http://smartsurfer.web.de/?mc=100071&distributionid=000000000066

