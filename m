Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498Ab0AUEGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab0AUEGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187Ab0AUEGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:06:35 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:58696 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab0AUEGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:06:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=W5cx2FJXzJxKCmRpk/KH3AD/AI9MxonbeBRiwU7zTJ5SIwQlkhqBQBwu0Rtdo8RXF7
         922xBjDaUj/kelunqCVr/Jkyzj8jKeV6u0MCPpknlWJpOsEXTBZJIh5jSfsOWFDvdTDv
         WjVcuXQuCUn5S6UxQPd3CFgi7v/BHBrIGAuVY=
Message-ID: <4B57D2C7.1000007@garzik.org>
Date: Wed, 20 Jan 2010 23:06:31 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/64] libata: fix CFA handling in ide_timing_compute()
References: <20100118171349.14623.90030.sendpatchset@localhost> <20100118171357.14623.36435.sendpatchset@localhost>
In-Reply-To: <20100118171357.14623.36435.sendpatchset@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2010 12:13 PM, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Subject: [PATCH] libata: fix CFA handling in ide_timing_compute()
>
> Use standard cycle timing for CFA PIO5 and PIO6 modes.
>
> Based on commit 74638c8 for IDE subsystem.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> ---
>   drivers/ata/libata-core.c |   17 +++++++++++------
>   1 file changed, 11 insertions(+), 6 deletions(-)

applied


