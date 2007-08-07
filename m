Return-Path: <linux-kernel-owner+w=401wt.eu-S1763310AbXHGMKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763310AbXHGMKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 08:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbXHGMKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 08:10:34 -0400
Received: from usish.com ([210.5.144.202]:34414 "EHLO sr-smtp.usish.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1762313AbXHGMKb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 08:10:31 -0400
X-Greylist: delayed 8357 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Aug 2007 08:10:29 EDT
From: "sam song" <sam_song@usish.com>
To: "'Tejun Heo'" <htejun@gmail.com>
Cc: "'Michael Sedkowski'" <sedmich@gmail.com>,
       "'Rafael J. Wysocki'" <rjw@sisk.pl>,
       "'Henrique de Moraes Holschuh'" <hmh@hmh.eng.br>,
       <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
       <linux-acpi@vger.kernel.org>
References: <838f88840708051428p3d65ff42w627af4bc38f57de3@mail.gmail.com>	 
	<1186411815.4355.7.camel@nx6310>	 
	<20070806150159.GC31615@khazad-dum.debian.net>	 
	<200708061732.03425.rjw@sisk.pl>  <46B75459.9020204@gmail.com>	 
	<1186424492.4355.1.camel@nx6310>  <46B76BBC.9010107@gmail.com>	 
	<1186438698.4402.6.camel@nx6310>  <46B817AB.30105@gmail.com> 
	<1186478319.3705.3.camel@nx6310> <46B83C0B.8050902@gmail.com>
Subject: =?utf-8?Q?=E7=AD=94=E5=A4=8D=3A_Disk_spin_down_issue_on_s?=
	=?utf-8?Q?hut_down=2Fsuspend_to_disk?=
Date: Tue, 7 Aug 2007 17:51:52 +0800
Message-ID: <000601c7d8d8$959c9130$5f39a8c0@usish.com.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcfY1dxcw084fTglQWG01roIsiEjnAAAfNlw
In-Reply-To: <46B83C0B.8050902@gmail.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-imss-version: 2.047
X-imss-result: Passed
X-imss-scanInfo: M:P L:N SM:0
X-imss-tmaseResult: TT:0 TS:0.0000 TC:00 TRN:0 TV:3.6.1039(15346.003)
X-imss-scores: Clean:99.90000 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:1 C:2 M:3 S:4 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Michael Sedkowski wrote:
> > Dnia 07-08-2007, Wt o godzinie 15:56 +0900, Tejun Heo napisał(a):
> >> 192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
> >> Always       -       388
[snip]
> On power off, the r/w heads in a disk should be unloaded (parked).  This
> is usually achieved by either putting the disk into standby/sleep mode
> during shutdown.  However, all modern disks can automatically unload
> their heads when the power is removed abruptly.  This is called
> emergency unload.  Emergency unload does shorten the lifespan of the
> disk but you don't have to worry too much about it.  Disks are designed
> to withstand certain number of emergency unloads.

Out of interest, does Power-Off_Retract_Count attribute only record emergency unloads
rather than normal power off by Linux shutdown command?

Thanks in advance,

Sam

