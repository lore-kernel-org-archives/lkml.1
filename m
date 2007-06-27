Return-Path: <linux-kernel-owner+w=401wt.eu-S1761086AbXF0OCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761086AbXF0OCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 10:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbXF0OCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 10:02:34 -0400
Received: from mailgw12.fraunhofer.de ([153.96.1.24]:47635 "EHLO
	mailgw12.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbXF0OCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 10:02:33 -0400
Date: Wed, 27 Jun 2007 16:00:02 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: harald@skogtun.org
Cc: david@lang.hm, dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       schilling@fokus.fraunhofer.de
Subject: Re: Linux Kernel include files
Message-ID: <46826d62.lTsuVo9cC7wGjcjf%Joerg.Schilling@fokus.fraunhofer.de>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 Jun 2007 14:02:01.0235 (UTC) FILETIME=[BBCE6E30:01C7B8C3]
X-Fraunhofer-Email-Policy: accepted
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Harald Arnesen <harald@skogtun.org> wrote:

> Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling) writes:
>
> >> If I actually install smake, as Jörg recommends, the message becomes:
> >> smake: Can't find any source for 'CCOM_suncc'.
> >> smake: Couldn't make 'CCOM_suncc'.
> >
> > Well, I was in hope that a small typo (in special as the correct spelling is in 
> > the file README.compile) should not be a problem.
> >
> > You need to use CCOM=suncc 
>
> Then it (star, I haven't tried cdrtools yes) compiles and links fine.
> There must be something wrong with your Linux installation.

Maybe because it automatically deactivates the Linux extensions if the 
autoconfiguration sees broken include files. Did you see something like:

checking if Linux include file linux/ext2_fs.h is broken... yes
checking if Linux include file /usr/src/linux/include/linux/ext2_fs.h is broken... yes
checking if Linux include file scsi/scsi.h is broken... no
checking if Linux include file /usr/src/linux/include/scsi/scsi.h is broken... no
checking if Linux include file scsi/sg.h is broken... no
checking if Linux include file /usr/src/linux/include/scsi/sg.h is broken... no

Warning: *** /usr/src/linux/include contains broken include files ***
Warning: *** /usr/src/linux/include is not used this reason ***
Warning: This may result in the inability to use recent Linux kernel interfaces


Warning: *** linux/ext2_fs.h is not usable at all ***
Warning: *** This makes it impossible to support Linux file flags ***
You may try to compile using 'make COPTX=-DTRY_EXT2_FS'

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
