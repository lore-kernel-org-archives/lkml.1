Return-Path: <linux-kernel-owner+w=401wt.eu-S1760569AbZKZRWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760569AbZKZRWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 12:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759017AbZKZRWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 12:22:21 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:27171 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1756432AbZKZRWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 12:22:21 -0500
Message-ID: <4B0EB986.2010801@ru.mvista.com>
Date: Thu, 26 Nov 2009 20:23:18 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_it8213: MWDMA0 is unsupported
References: <200911261728.36433.bzolnier@gmail.com> <200911261800.55025.bzolnier@gmail.com>
In-Reply-To: <200911261800.55025.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

>>MWDMA0 timings cannot be met with the PIIX based controller
>>programming interface.

>>This change should be safe as this is how we have been doing
>>things in IDE it8213 host driver for years.

>>Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>---
>>Verified with the documentation (similar case as with pata_efar).

> Uhhh, no...

> Too many damn drivers.

> Too much damn duplication.

> Too much damn subtle differences here and there.

> The hardware is probably fine for MWMDA0 when it comes to pata_{efar,it8213},
> it just not documented properly in the data sheet.

    How so with pata_efar? The active/recovery bitfields are still 2-bit 
wide, no?

> I'll drop those two patches from my tree and take some break..

    Taking a break is good, not sure about dropping yet.

MBR, Sergei
