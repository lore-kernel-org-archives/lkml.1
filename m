Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbXJ3S0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbXJ3S0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 14:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbXJ3S0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 14:26:43 -0400
Received: from hpsmtp-eml18.kpnxchange.com ([213.75.38.118]:22888 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752920AbXJ3S0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 14:26:42 -0400
To: Daniel Drake <dsd@gentoo.org>
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
Cc: alan@lxorguk.ukuu.org.uk, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-To: <47276DCA.1000808@gentoo.org>
References: <47274A5F.6070409@gentoo.org> <20071030153417.59b9182c@the-village.bc.nu> <47276DCA.1000808@gentoo.org>
Message-Id: <E1ImvnU-0002Uq-Kh@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Tue, 30 Oct 2007 19:26:40 +0100
X-OriginalArrivalTime: 30 Oct 2007 18:26:41.0031 (UTC) FILETIME=[6A89C170:01C81B22]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Drake wrote:
> I have narrowed down the exact command submission which causes those
> nasty messages in dmesg. The function which submits this is named
> "brasero_medium_get_page_2A_write_speed_desc".

Just as an extra data point...

I've compiled the test program an ran it on my ICH7/Pentium D box running
2.6.24-rc1-192-gef49c32 (x86_64), but it does not give the error and
nothing in dmesg. I just get:
result 0

My SATA DVD-RW drive is:
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: Optiarc  Model: DVD RW AD-7170S  Rev: 1.00
  Type:   CD-ROM                           ANSI  SCSI revision: 05
