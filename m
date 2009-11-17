Return-Path: <linux-kernel-owner+w=401wt.eu-S1756450AbZKQWgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbZKQWgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756390AbZKQWgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:36:40 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:54570 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756346AbZKQWgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:36:39 -0500
Message-ID: <4B03256C.5000201@garzik.org>
Date: Tue, 17 Nov 2009 17:36:28 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 4/5] pata: Update experimental tags
References: <20091117144450.15430.83450.stgit@localhost.localdomain> <20091117145137.15430.11229.stgit@localhost.localdomain>
In-Reply-To: <20091117145137.15430.11229.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2009 09:51 AM, Alan Cox wrote:
> Signed-off-by: Alan Cox<alan@linux.intel.com>
> ---
>
>   drivers/ata/Kconfig |    8 ++++----
>   1 files changed, 4 insertions(+), 4 deletions(-)
>
>
> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index f2df6e2..36931e0 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -374,7 +374,7 @@ config PATA_HPT366
>   	  If unsure, say N.
>
>   config PATA_HPT37X
> -	tristate "HPT 370/370A/371/372/374/302 PATA support (Experimental)"
> +	tristate "HPT 370/370A/371/372/374/302 PATA support"
>   	depends on PCI&&  EXPERIMENTAL


When you change the help string, you must also change the 'depends' line.

	Jeff




