Return-Path: <linux-kernel-owner+w=401wt.eu-S1763307AbYBHReD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763307AbYBHReD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 12:34:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758826AbYBHRdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 12:33:49 -0500
Received: from homer.mvista.com ([63.81.120.155]:60976 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757178AbYBHRds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 12:33:48 -0500
Message-ID: <47AC92B0.4080408@ru.mvista.com>
Date: Fri, 08 Feb 2008 20:34:40 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Anton Salnikov <asalnikov@ru.mvista.com>
Subject: Re: [PATCH 3/3] palm_bk3710: factor out cable detection
References: <200802071542.29628.bzolnier@gmail.com> <47AB1882.8060103@ru.mvista.com> <58cb370e0802070814y44e37cf4h91f57fd4bc993133@mail.gmail.com> <200802072151.49510.bzolnier@gmail.com>
In-Reply-To: <200802072151.49510.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] palm_bk3710: use struct ide_port_info

> * Factor out cable detection to palm_bk3710_cable_detect().

> * Add palm_bk3710_init_hwif() (->init_hwif method implementation).

> * Remove needless ->quirkproc initialization.

> * Add missing ->pio_mask initialization.

> * Use ATA_* defines for setting ->{ultra,mwdma}_mask.

> * Add 'struct ide_port_info palm_bk3710_port_info' and pass it to
>   ide_device_add().  Then remove open-coded 'hwif' initialization.

> Cc: Anton Salnikov <asalnikov@ru.mvista.com>
> Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
