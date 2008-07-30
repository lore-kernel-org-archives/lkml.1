Return-Path: <linux-kernel-owner+w=401wt.eu-S1761350AbYG3BDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761350AbYG3BDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 21:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758169AbYG3A67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:58:59 -0400
Received: from cnrelay03.alcatel-sbell.com.cn ([211.144.215.19]:52817 "EHLO
	mail.alcatel-sbell.com.cn" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758112AbYG3A65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:58:57 -0400
Message-ID: <488FBCB4.4080609@alcatel-lucent.com>
Date: Wed, 30 Jul 2008 08:58:28 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: PIIX4: DMA timeout issue
References: <488ED837.2060509@alcatel-lucent.com> 
	<488F1C6C.9000002@garzik.org>
In-Reply-To: <488F1C6C.9000002@garzik.org>
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jul 2008 00:58:18.0459 (UTC) 
	FILETIME=[5ADE7AB0:01C8F1DF]
X-imss-version: 2.051
X-imss-result: Passed
X-imss-scores: Clean:78.33446 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:2 C:1 M:1 S:1 R:1 (0.1500 0.1500)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> gshan wrote:
>> Hello, I sent mails on this issue before, but nobody made response.
>> There are 2 types of board for me. The hardware configuration for
>> those 2 boards are almost same except that one of them has 100GB
>> harddisk, and another type of board has 60GB harddisk. All harddisk
>> was access through PIIX4. I found this issue on board with 60GB
>> disk, but can't reproduce it on that with 100GB disk.
>>
>> When I uncompressed a large file (600MB) to a logic partition with 8GB
>> size, following errors was report on middle way (5 minutes about from 
>> start).
>> Anybody has ideas?
>>
>> hdc: dma_timer_expiry: dma status == 0x21
>> hdc: DMA timeout error
>> hdc: dma timeout error: status=0x58 { DriveReady SeekComplete 
>> DataRequest }
>> ide: failed opcode was: unknown
>> hdc: DMA disabled
>> ide1: reset: success
>
> Can you try disabling the IDE driver (CONFIG_IDE) and enabling the 
> newer libata driver?  (CONFIG_ATA)
Jeff, thanks a lot for your suggestions. I will try it if possible.
>
>     Jeff
>
>
>
>

