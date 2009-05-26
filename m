Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbZEZH5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbZEZH5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 03:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbZEZH4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 03:56:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33827 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752554AbZEZH4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 03:56:51 -0400
Date: Tue, 26 May 2009 08:56:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: yanh@lemote.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       =?UTF-8?B?6IOh5rSq5YW1?= <huhb@lemote.com>, wuzhangjin@gmail.com,
       linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Zhang Fuxin <zhangfx@lemote.com>, Arnaud Patard <apatard@mandriva.com>,
       loongson-dev@googlegroups.com, gnewsense-dev@nongnu.org,
       Nicholas Mc Guire <hofrat@hofr.at>, Liu Junliang <liujl@lemote.com>,
       Erwan Lerale <erwan@thiscow.com>
Subject: Re: [loongson-PATCH-v1 24/27] fixup for FUJITSU disk
Message-ID: <20090526085605.014d0087@lxorguk.ukuu.org.uk>
In-Reply-To: <1243300890.9819.40.camel@localhost.localdomain>
References: <cover.1242855716.git.wuzhangjin@gmail.com>
	<1243230339.9819.18.camel@localhost.localdomain>
	<4A1A4A54.6090401@lemote.com>
	<200905251656.25357.bzolnier@gmail.com>
	<4A1AEBF7.7040402@ru.mvista.com>
	<yq1tz39dmmn.fsf@sermon.lab.mkp.net>
	<1243300890.9819.40.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > In any case I have yet to see a CS5536 system whose BIOS sets the cable
> > detection bit.  If that's the problem I guess we could add a quirk flag
> > to override the (lack of) BIOS setting.
> > 
> This may be the cause that udma5 cannot be set.


If the system doesn't have working BIOS cable detect as per the
documentation for the chip then just return the "unknown" cable type and
libata will do device side cable detect.

Alan
