Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352AbYJPGVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbYJPGVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 02:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYJPGVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 02:21:38 -0400
Received: from cnmailgate04.alcatel-sbell.com.cn ([211.144.215.47]:46133 "EHLO
	cnshjsmin03.cn.alcatel-lucent.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753602AbYJPGVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 02:21:37 -0400
X-AuditID: ac189297-aa780bb000000fe5-a8-48f6dd41498a
Message-ID: <48F6DD54.70004@alcatel-lucent.com>
Date: Thu, 16 Oct 2008 14:21:08 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: how to limit number of sectors each time
References: <48F6B51B.2000408@alcatel-lucent.com> <20081016054400.GN19428@kernel.dk> <48F6DA7A.9080003@alcatel-lucent.com> <20081016061808.GS19428@kernel.dk>
In-Reply-To: <20081016061808.GS19428@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Oct 2008 06:20:56.0240 (UTC) FILETIME=[5939F300:01C92F57]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> (please never send out html only emails, it's considered very bad style
> on this list)
>
> Sounds like you need a quirk/blacklist entry for that drive, if it
> doesn't support 0x00 as meaning 256 sectors. If you are using libata,
> you can add a ATA_HORKAGE_MAX_SEC_128 entry to ata_device_blacklist[] in
> drivers/ata/libata-core.c
>   
I'm using IDE driver instead of HD driver.

