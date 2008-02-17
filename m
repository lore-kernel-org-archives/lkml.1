Return-Path: <linux-kernel-owner+w=401wt.eu-S1755078AbYBQXcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbYBQXcc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 18:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755294AbYBQXcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 18:32:23 -0500
Received: from mailgw2-out.fraunhofer.de ([153.96.1.22]:58860 "EHLO
	mailgw2-out.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbYBQXcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 18:32:22 -0500
X-Greylist: delayed 649 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Feb 2008 18:32:21 EST
Date: Mon, 18 Feb 2008 00:21:27 +0100
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc1/2 CD/DVD burning broken
Message-ID: <47b8c177.2QDr0ADTa5ExM+/T%Joerg.Schilling@fokus.fraunhofer.de>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 17 Feb 2008 23:21:27.0724 (UTC) FILETIME=[D2116EC0:01C871BB]
X-Fraunhofer-Email-Policy: accepted
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> changing ide-cd (take 4)] I cannot burn any CD/DVD any more, getting the 
> following error from wodim: 

> Errno: 0 (Success), write_g1 scsi sendcmd: no error 
> CDB:  2A 00 00 00 00 00 00 00 1F 00 
> status: 0x2 (CHECK CONDITION) 
> Sense Bytes: 70 00 05 00 00 00 00 0E 00 00 00 00 21 02 00 00 
> Sense Key: 0x5 Illegal Request, Segment 0 
> Sense Code: 0x21 Qual 0x02 (invalid address for write) Fru 0x0 
> Sense flags: Blk 0 (not valid) 
> resid: 63488 

This fragment is much too short to allow to judge on possible reasons.
There is a high probability that your problem is caused by the cdrecord
fork called "wodim".

Please always include the following information in your bug-report: 

- The version number of cdrecord that caused the bug. 
- The command line that was used for the failing command. 
- The complete output (including error messages) from 'cdrecord -v ...' 
- Probably the important part of the 'cdrecord -V' output if we agreed on it 
- The OS name, release and hardware (processor) 
- Special conditions of your environment (libc vers. SCSI transport ...) 
- Sufficient information on the media used. This is at least the ATIP data, a 
  note to CD-R/CD-RW and information on the state and the case history of this
  media. 

As a general advise: if you have problems, always first try recent original 
software from

ftp://ftp.berlios.de/pub/cdrecord/alpha/

None of the 30+ bugs reported against wodim in various Linux distributions is 
known to be present with recent original software.

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
