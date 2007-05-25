Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbXEYAH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbXEYAH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 20:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbXEYAHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 20:07:47 -0400
Received: from terminus.zytor.com ([192.83.249.54]:60327 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbXEYAHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 20:07:46 -0400
Message-ID: <4656284D.7080709@zytor.com>
Date: Thu, 24 May 2007 17:05:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.22-rc1-mm1: IDE compile error
References: <20070515201914.16944e04.akpm@linux-foundation.org>	<20070516185552.GA4086@stusta.de>	<200705240145.38055.bzolnier@gmail.com> <20070524115549.01c0e1ca@the-village.bc.nu>
In-Reply-To: <20070524115549.01c0e1ca@the-village.bc.nu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> 
> hd.c can drive MFM and RLL disks and drivers/ide cannot. Although it
> really wants burying further down the config tree the ability to read MFM
> and RLL disks when recovering ancient data is useful and people do
> actually use this driver now and then rescuing stuff like twenty year old
> datasets.
> 
> It thus needs fixing not removing.
> 

Opinions, anyone (especially Alan):

http://git.kernel.org/?p=linux/kernel/git/hpa/linux-2.6-newsetup.git;a=commitdiff;h=369f16fdd423d79640c4390915e6ab71189cb497

	-hpa
