Return-Path: <linux-kernel-owner+w=401wt.eu-S1759426AbXFUR5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426AbXFUR5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756422AbXFUR44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:56:56 -0400
Received: from h155.mvista.com ([63.81.120.155]:64557 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756066AbXFUR4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:56:55 -0400
Message-ID: <467ABC4D.5010004@ru.mvista.com>
Date: Thu, 21 Jun 2007 21:58:37 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linas Vepstas <linas@austin.ibm.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Stuart_Hayes@dell.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] ide dma_timer_expiry, then hard lockup
References: <20070618175713.GD5836@austin.ibm.com>	<4677FFF1.2010308@ru.mvista.com>	<20070619164854.GR5836@austin.ibm.com>	<200706192043.40298.bzolnier@gmail.com>	<46783777.10607@ru.mvista.com>	<20070620162845.GY5836@austin.ibm.com> <20070620180123.642316ae@the-village.bc.nu>
In-Reply-To: <20070620180123.642316ae@the-village.bc.nu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alan Cox wrote:

>>Google seems to show that there is no publically available 
>>firmware updates for Maxtor disks.

> There are for some but only if you irritate the tech support people.

>>hours at high cpu usage.... There were maybe a a dozen DriveReady
>>SeekComplete Timeout errors clustered a few minutes apart.  

> That suggests the drive is having problems occassionally and that the DMA
> path code then blows up when they occur.

>>Is there a way of viewing the contents of he command queue on
>>the hard drive, to see if the command actually made it across?

> queue ? You are overestimating IDE ;)

    He's not -- there is queued commands support since ATA[PI]-5. I'm not sure 
why but Linux decided not to support it.

MBR, Sergei
