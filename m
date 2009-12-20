Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbZLTUqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbZLTUqQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 15:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756147AbZLTUqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 15:46:10 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:53449 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087AbZLTUqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 15:46:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AJaMi75RJehnSYZf815bj4p6wg7wV4NLgwKelzb3xoDgHT+NKHd0GMd5FtdE0rXfWF
         nSY9m9htYV3L02CwjuzUNliBvpPtxzfNwm2NCHgJ/U3ts+/5+aO2ZJMnuD8Dza612Gx+
         +Hui+O8yJOV1vFJDzLyIi1WLGBltVJbZmqXU0=
Message-ID: <4B2E8D09.4060705@garzik.org>
Date: Sun, 20 Dec 2009 15:46:01 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] pata_cmd64x: fix overclocking of UDMA0-2 modes
References: <200912201922.33210.bzolnier@gmail.com>
In-Reply-To: <200912201922.33210.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2009 01:22 PM, Bartlomiej Zolnierkiewicz wrote:
>
> adev->dma_mode stores the transfer mode value not UDMA mode number
> so the condition in cmd64x_set_dmamode() is always true and the higher
> UDMA clock is always selected.  This can potentially result in data
> corruption when UDMA33 device is used, when 40-wire cable is used or
> when the error recovery code decides to lower the device speed down.
>
> The issue was introduced in the commit 6a40da0 ("libata cmd64x: whack
> into a shape that looks like the documentation") which goes back to
> kernel 2.6.20.
>
> Cc: stable@kernel.org
> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> ---
> it is patch #116 in my local working queue but I thought it would
> be nice to get it upstream ahead of other patches..
>
>   drivers/ata/pata_cmd64x.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

applied


