Return-Path: <linux-kernel-owner+w=401wt.eu-S1753778AbZEYTQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbZEYTQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 15:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbZEYTQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 15:16:19 -0400
Received: from h155.mvista.com ([63.81.120.155]:49669 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752563AbZEYTQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 15:16:18 -0400
Message-ID: <4A1AEEBC.2080108@ru.mvista.com>
Date: Mon, 25 May 2009 23:17:16 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       =?UTF-8?B?6IOh5rSq5YW1?= <huhb@lemote.com>, yanh@lemote.com,
       wuzhangjin@gmail.com, linux-mips@linux-mips.org,
       Ralf Baechle <ralf@linux-mips.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Zhang Fuxin <zhangfx@lemote.com>, Arnaud Patard <apatard@mandriva.com>,
       loongson-dev@googlegroups.com, gnewsense-dev@nongnu.org,
       Nicholas Mc Guire <hofrat@hofr.at>, Liu Junliang <liujl@lemote.com>,
       Erwan Lerale <erwan@thiscow.com>
Subject: Re: [loongson-PATCH-v1 24/27] fixup for FUJITSU disk
References: <cover.1242855716.git.wuzhangjin@gmail.com>	<1243230339.9819.18.camel@localhost.localdomain>	<4A1A4A54.6090401@lemote.com> <200905251656.25357.bzolnier@gmail.com>	<4A1AEBF7.7040402@ru.mvista.com> <yq1tz39dmmn.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1tz39dmmn.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Martin K. Petersen wrote:

>>>Could you please explain the issue with platform specific code a bit
>>>more?

>>>Is it related to a cable detection by any chance?

> Sergei>    I guess it's rdmsr()/wrmsr()...

> Those are only used when the driver is explicitly loaded with
> use_msr=1.  The default is to use PCI config space/VSA.

    But you need them defined for the driver to build...

MBR, Sergei
