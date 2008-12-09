Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbYLITE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbYLITE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 14:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbYLITEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 14:04:20 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:25161 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbYLITEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 14:04:20 -0500
Date: Tue, 9 Dec 2008 20:04:09 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-i2c@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/33] i2c: Make static
Message-ID: <20081209200409.17fac29f@hyperion.delvare>
In-Reply-To: <493EBBD0.6070201@gmail.com>
References: <493EA286.7080500@gmail.com>
	<493EBBD0.6070201@gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Dec 2008 19:41:20 +0100, Roel Kluin wrote:
> Sparse asked whether these could be static.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/i2c/i2c-core.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index c6a63f4..1049615 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -1699,7 +1699,8 @@ EXPORT_SYMBOL(i2c_smbus_write_word_data);
>   * This executes the SMBus "process call" protocol, returning negative errno
>   * else a 16-bit unsigned "word" received from the device.
>   */
> -s32 i2c_smbus_process_call(struct i2c_client *client, u8 command, u16 value)
> +static s32 i2c_smbus_process_call(struct i2c_client *client, u8 command,
> +		u16 value)
>  {
>  	union i2c_smbus_data data;
>  	int status;

Nack:

drivers/i2c/i2c-core.c:EXPORT_SYMBOL(i2c_smbus_process_call);

-- 
Jean Delvare
