Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbZEZBWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbZEZBWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 21:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZEZBV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 21:21:59 -0400
Received: from [222.92.8.141] ([222.92.8.141]:48417 "EHLO lemote.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbZEZBV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 21:21:58 -0400
Subject: Re: [loongson-PATCH-v1 24/27] fixup for FUJITSU disk
From: yanh <yanh@lemote.com>
Reply-To: yanh@lemote.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       =?gb2312?Q?=BA=FA=BA=E9=B1=F8?= <huhb@lemote.com>, wuzhangjin@gmail.com,
       linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Zhang Fuxin <zhangfx@lemote.com>, Arnaud Patard <apatard@mandriva.com>,
       loongson-dev@googlegroups.com, gnewsense-dev@nongnu.org,
       Nicholas Mc Guire <hofrat@hofr.at>, Liu Junliang <liujl@lemote.com>,
       Erwan Lerale <erwan@thiscow.com>
In-Reply-To: <yq1tz39dmmn.fsf@sermon.lab.mkp.net>
References: <cover.1242855716.git.wuzhangjin@gmail.com>
	 <1243230339.9819.18.camel@localhost.localdomain>
	 <4A1A4A54.6090401@lemote.com> <200905251656.25357.bzolnier@gmail.com>
	 <4A1AEBF7.7040402@ru.mvista.com>  <yq1tz39dmmn.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 May 2009 09:21:30 +0800
Message-Id: <1243300890.9819.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2009-05-25一的 15:10 -0400，Martin K. Petersen写道：
> >>>>> "Sergei" == Sergei Shtylyov <sshtylyov@ru.mvista.com> writes:
> 
> >> Could you please explain the issue with platform specific code a bit
> >> more?
> 
> >> Is it related to a cable detection by any chance?
> 
> Sergei>    I guess it's rdmsr()/wrmsr()...
currently, we just commented out the rdmsr/wrmsr.
and we use pci VSA to access it. 
> 
> Those are only used when the driver is explicitly loaded with
> use_msr=1.  The default is to use PCI config space/VSA.
> 
> In any case I have yet to see a CS5536 system whose BIOS sets the cable
> detection bit.  If that's the problem I guess we could add a quirk flag
> to override the (lack of) BIOS setting.
> 
This may be the cause that udma5 cannot be set.

