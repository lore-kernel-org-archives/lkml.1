Return-Path: <linux-kernel-owner+w=401wt.eu-S1760626AbYDLHad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760626AbYDLHad (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 03:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbYDLHaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 03:30:25 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:35950 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316AbYDLHaY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 03:30:24 -0400
Date: Sat, 12 Apr 2008 09:30:22 +0200
Message-Id: <236054348@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: ls.luis_sousa@yahoo.com.br
Cc: linux-kernel@vger.kernel.org
Subject: Re: sata io freeze, 2.6.18 and also 2.6.24
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18yDVlfWeY0ztgIRjSybjpX2AZmBL4Uh43DH9HCmPmDd9vDh
 75KgjO7bqA6CemJ2Je1O9tm7931lzcD/PmCFMplprJBkU5rMk8=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

did you try UP-kernel or tried booting with "nosmp" and does that make any difference ?

>This is a 2-processor CPU:
># cat /proc/cpuinfo 
>processor       : 0
>vendor_id       : GenuineIntel
>cpu family      : 15
>model           : 4
>model name      : Intel(R) Pentium(R) 4 CPU 3.00GHz

most likely this just "appears" as 2-way processor , but i´m quite sure this is just a single-core CPU, but with HyperThreading enabled.


regards
roland



List:       linux-kernel
Subject:    sata io freeze, 2.6.18 and also 2.6.24
From:       Luis Sousa <ls.luis_sousa () yahoo ! com ! br>
Date:       2008-03-28 22:24:48
Message-ID: 739784.81690.qm () web46009 ! mail ! sp1 ! yahoo ! com
[Download message RAW]

Hello,

I've been having consistent hard system freezes for a
long time, every 2 days or so, and finally decided to
move to the most recent stable kernel. Unfortunatelly
that didn't fix it. The freezes seem to be io-related;
they started since I moved my drive to sata. They seem
to happen mostly when there's an io-intensive operation,
like extracting a big archive; a reboot is needed.

Nothing ever shows up in the logs.

I'm using the following drive:

ATA device, with non-removable media
        Model Number:       MAXTOR STM3160215AS                     
        Serial Number:      6RA2TMJ4
        Firmware Revision:  3.AAD   

Linux localhost 2.6.24.4 #4 SMP Fri Mar 28 14:51:50 BRT 2008 i686 GNU/Linux

This is a 2-processor CPU:

# cat /proc/cpuinfo 
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 4
model name      : Intel(R) Pentium(R) 4 CPU 3.00GHz
stepping        : 9
cpu MHz         : 3013.697
cache size      : 1024 KB

(same goes for processor : 1)

Sincerely,
--
Luis Sousa
_____________________________________________________________________
Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
http://smartsurfer.web.de/?mc=100071&distributionid=000000000066

