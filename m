Return-Path: <linux-kernel-owner+w=401wt.eu-S932812AbZKXLNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbZKXLNB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 06:13:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932765AbZKXLNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 06:13:00 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:50570 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S932706AbZKXLM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 06:12:59 -0500
Message-ID: <4B0BBFB1.20802@ru.mvista.com>
Date: Tue, 24 Nov 2009 14:12:49 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Hemant Pedanekar <hemantp@ti.com>
Cc: linux-ide@vger.kernel.org, davem@davemloft.net, bzolnier@gmail.com,
       petkovbb@gmail.com, christian.engelmayer@frequentis.com,
       linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH] ide: fix ioctl to pass requested transfer mode to ide_find_dma_mode
 instead of UDMA6
References: <1259036188-11598-1-git-send-email-hemantp@ti.com>
In-Reply-To: <1259036188-11598-1-git-send-email-hemantp@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Hemant Pedanekar wrote:
> Currently, ide_cmd_ioctl when invoked for setting DMA transfer mode calls
> ide_find_dma_mode with requested mode as XFER_UDMA_6. This prevents setting DMA
> mode to any other value than the default (maximum) supported by the device (or
> UDMA6, if supported) irrespective of the actual requested transfer mode and
> returns error.
>
> For example, setting mode to UDMA2 using hdparm, where UDMA4 is the default
> transfer mode gives following error:
> 	# ./hdparm -d1 -Xudma2  /dev/hda
> 	 /dev/hda:hda: UDMA/66 mode selected
> 	 setting using_dma to 1 (on)
> 	 hda: UDMA/66 mode selected
> 	 setting xfermode to 66 (UltraDMA mode2)
> 	 HDIO_DRIVE_CMD(setxfermode) failed: Invalid argument
> 	 using_dma     =  1 (on)
>
> This patch fixes the issue.
>
> Signed-off-by: Hemant Pedanekar <hemantp@ti.com>
> Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei


