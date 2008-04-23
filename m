Return-Path: <linux-kernel-owner+w=401wt.eu-S1754269AbYDWKTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbYDWKTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 06:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYDWKTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 06:19:16 -0400
Received: from smtprelay07.ispgateway.de ([80.67.29.7]:44576 "EHLO
	smtprelay07.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbYDWKTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 06:19:15 -0400
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Apr 2008 06:19:15 EDT
Message-ID: <480F0B93.2040208@selhorst.net>
Date: Wed, 23 Apr 2008 12:12:35 +0200
From: Marcel Selhorst <tpm@selhorst.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080229)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [2.6 patch] tpm_bios.c: make 2 structs static
References: <20080423095036.GN28933@cs181133002.pp.htv.fi>
In-Reply-To: <20080423095036.GN28933@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.1-5; AVE: 7.8.0.8; VDF: 7.0.3.201; host: mail)
X-Df-Sender: 174499
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Marcel Selhorst <tpm@selhorst.net>

Adrian Bunk schrieb:
> This patch makes two needlessly global structs static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
> This patch has been sent on:
> - 14 Apr 2008
> - 31 Mar 2008
> 
>  drivers/char/tpm/tpm_bios.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 030a8d37553ae500a00cd0005c763863452b7cbc diff --git a/drivers/char/tpm/tpm_bios.c b/drivers/char/tpm/tpm_bios.c
> index 60a2d26..68f052b 100644
> --- a/drivers/char/tpm/tpm_bios.c
> +++ b/drivers/char/tpm/tpm_bios.c
> @@ -448,7 +448,7 @@ out_free:
>  	goto out;
>  }
>  
> -const struct file_operations tpm_ascii_bios_measurements_ops = {
> +static const struct file_operations tpm_ascii_bios_measurements_ops = {
>  	.open = tpm_ascii_bios_measurements_open,
>  	.read = seq_read,
>  	.llseek = seq_lseek,
> @@ -486,7 +486,7 @@ out_free:
>  	goto out;
>  }
>  
> -const struct file_operations tpm_binary_bios_measurements_ops = {
> +static const struct file_operations tpm_binary_bios_measurements_ops = {
>  	.open = tpm_binary_bios_measurements_open,
>  	.read = seq_read,
>  	.llseek = seq_lseek,

