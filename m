Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbYGVJyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbYGVJyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 05:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbYGVJyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 05:54:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778AbYGVJyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 05:54:01 -0400
Date: Tue, 22 Jul 2008 02:53:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch 1/5] x86: ACPI - add checking for NULL early param
Message-Id: <20080722025332.afddd49b.akpm@linux-foundation.org>
In-Reply-To: <486f61a9.2135440a.0d16.ffffbd7f@mx.google.com>
References: <20080705115334.892720771@gmail.com>
	<486f61a9.2135440a.0d16.ffffbd7f@mx.google.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 Jul 2008 15:53:35 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
> 
> Index: linux-2.6.git/drivers/acpi/tables.c
> ====================================================================
> --- linux-2.6.git.orig/drivers/acpi/tables.c	2008-01-21 23:14:47.000000000 +0300
> +++ linux-2.6.git/drivers/acpi/tables.c	2008-07-05 12:24:16.000000000 +0400
> @@ -300,6 +300,8 @@ int __init acpi_table_init(void)
>  
>  static int __init acpi_parse_apic_instance(char *str)
>  {
> +	if (!str)
> +		return -EINVAL;
>  
>  	acpi_apic_instance = simple_strtoul(str, NULL, 0);
>  

Could you please explain this patch?
