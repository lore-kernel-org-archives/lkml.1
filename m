Return-Path: <linux-kernel-owner+w=401wt.eu-S1760732AbYCYVst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760732AbYCYVst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756235AbYCYVsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:48:41 -0400
Received: from mailgw2-out.fraunhofer.de ([153.96.1.28]:63944 "EHLO
	mailgw2-out.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbYCYVsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:48:40 -0400
X-Greylist: delayed 495 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Mar 2008 17:48:39 EDT
Date: Tue, 25 Mar 2008 22:40:01 +0100
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: linux-kernel@vger.kernel.org, gjasny@googlemail.com
Subject: Re: Burning CDs as user produces coasters (Plextor drive)
Message-ID: <47e97131.1k52DAHmONbBI5xR%Joerg.Schilling@fokus.fraunhofer.de>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 25 Mar 2008 21:40:01.0395 (UTC) FILETIME=[C79E1430:01C88EC0]
X-Fraunhofer-Email-Policy: accepted
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>since some time burning ISO CD images as user fails.
>Wodim stops during OPC and the kernel prints some messages:

>scsi: unknown opcode 0xe9
>scsi: unknown opcode 0xed
>scsi: unknown opcode 0xf5
>scsi: unknown opcode 0xeb

>If I burn as root, everything works fine. The used CD writer is a
>"PLEXTOR  DVDR   PX-712A   1.09". I've seen in the wodim/cdrecord
>sources that plextor drives are handled different from other drives.

One of the known bugs in "wodium" is that it tries to keep you missinformed
about the fact that you need root privileges in order to write CDs on Linux.

The official cdrecord does not have this problem, it informs you early about
missing root privileges.

I recommend you to get a recent original from:

ftp://ftp.berlios.de/pub/cdrecord/alpha/

compile it and install it suid root. Readcd and cdda2wav also need root 
privileges in order to work.

BTW: at the Linuxtage in Chemnitz, I got a hint from Chris Friedhoff that 
recent linux kernel seem to include a method that could help to avoid root 
privileges. He told me that he is going to provide a patch for cdrtools
and I am waiting on his next reply....

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
