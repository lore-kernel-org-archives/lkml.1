Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbYAQL5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbYAQL5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 06:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbYAQL5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 06:57:11 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:57048 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750955AbYAQL5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 06:57:10 -0500
Message-ID: <478F4284.9010706@suse.de>
Date: Thu, 17 Jan 2008 14:56:52 +0300
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: EC: add leading zeros to debug messages
References: <478F02FF.7040402@freemail.hu>
In-Reply-To: <478F02FF.7040402@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marton,
Could you please attach these patches to bug report? It is easier to track them there.

Thanks,
Alex.

Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> Add leading zeros to pr_debug() calls. For example if x=0x0a, the format
> "0x%2x" will result the string "0x a", the format "0x%2.2x" will result "0x0a".
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
> --- linux-2.6.24-rc8/drivers/acpi/ec.c.orig	2008-01-16 07:25:33.000000000 +0100
> +++ linux-2.6.24-rc8/drivers/acpi/ec.c	2008-01-17 07:15:10.000000000 +0100
> @@ -138,26 +138,26 @@ static struct acpi_ec {
>  static inline u8 acpi_ec_read_status(struct acpi_ec *ec)
>  {
>  	u8 x = inb(ec->command_addr);
> -	pr_debug(PREFIX "---> status = 0x%2x\n", x);
> +	pr_debug(PREFIX "---> status = 0x%2.2x\n", x);
>  	return x;
>  }
> 
>  static inline u8 acpi_ec_read_data(struct acpi_ec *ec)
>  {
>  	u8 x = inb(ec->data_addr);
> -	pr_debug(PREFIX "---> data = 0x%2x\n", x);
> +	pr_debug(PREFIX "---> data = 0x%2.2x\n", x);
>  	return inb(ec->data_addr);
>  }
> 
>  static inline void acpi_ec_write_cmd(struct acpi_ec *ec, u8 command)
>  {
> -	pr_debug(PREFIX "<--- command = 0x%2x\n", command);
> +	pr_debug(PREFIX "<--- command = 0x%2.2x\n", command);
>  	outb(command, ec->command_addr);
>  }
> 
>  static inline void acpi_ec_write_data(struct acpi_ec *ec, u8 data)
>  {
> -	pr_debug(PREFIX "<--- data = 0x%2x\n", data);
> +	pr_debug(PREFIX "<--- data = 0x%2.2x\n", data);
>  	outb(data, ec->data_addr);
>  }
> 

