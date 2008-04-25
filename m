Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbYDYFPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbYDYFPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 01:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbYDYFPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 01:15:33 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47151 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbYDYFPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 01:15:32 -0400
Message-ID: <481168F2.4080000@garzik.org>
Date: Fri, 25 Apr 2008 01:15:30 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Dan McGee <dpmcgee@gmail.com>
CC: htejun@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata_piix: add Asus Eee 701 controller to short cable
 list
References: <1208747007-9791-1-git-send-email-dpmcgee@gmail.com>
In-Reply-To: <1208747007-9791-1-git-send-email-dpmcgee@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan McGee wrote:
> The drive is directly soldered to the controller, so there is no cable at
> all. Remove the 40-wire assumption so the drive can operate at max speed.
> 
> Before patch:
> $ dd if=/dev/sda of=/dev/null bs=2M count=64 iflag=direct
> 134217728 bytes (134 MB) copied, 5.29612 s, 25.3 MB/s
> 
> After patch:
> $ dd if=/dev/sda of=/dev/null bs=2M count=64 iflag=direct
> 134217728 bytes (134 MB) copied, 3.94955 s, 34.0 MB/s
> 
> Signed-off-by: Dan McGee <dpmcgee@gmail.com>
> ---
>  drivers/ata/ata_piix.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
> index b7c38ee..ea2c764 100644
> --- a/drivers/ata/ata_piix.c
> +++ b/drivers/ata/ata_piix.c
> @@ -573,6 +573,7 @@ static const struct ich_laptop ich_laptop[] = {
>  	{ 0x27DF, 0x1043, 0x1267 },	/* ICH7 on Asus W5F */
>  	{ 0x27DF, 0x103C, 0x30A1 },	/* ICH7 on HP Compaq nc2400 */
>  	{ 0x24CA, 0x1025, 0x0061 },	/* ICH4 on ACER Aspire 2023WLMi */
> +	{ 0x2653, 0x1043, 0x82D8 },	/* ICH6M on Asus Eee 701 */

applied


