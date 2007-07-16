Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbXGPSST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbXGPSST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 14:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbXGPSSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 14:18:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60252 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbXGPSSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 14:18:08 -0400
Subject: Re: [PATCH] ACPI: Add reboot mechanism
From: Arjan van de Ven <arjan@infradead.org>
To: Aaron Durbin <adurbin@google.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       len.brown@intel.com, ak@suse.de, akpm@osdl.org
In-Reply-To: <20070716180019.GA5112@google.com>
References: <20070716180019.GA5112@google.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 16 Jul 2007 11:17:24 -0700
Message-Id: <1184609844.2698.1.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-16 at 11:00 -0700, Aaron Durbin wrote:
> Add the ability to reset the machine using the RESET_REG in ACPI's FADT table.
> 
> Signed-off-by: Aaron Durbin <adurbin@google.com>
> ---
> 
> diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
> index d4336f1..c9906a5 100644
> --- a/drivers/acpi/Makefile
> +++ b/drivers/acpi/Makefile
> @@ -21,7 +21,7 @@ obj-$(CONFIG_X86)		+= blacklist.o
>  #
>  # ACPI Core Subsystem (Interpreter)
>  #
> -obj-y				+= osl.o utils.o \
> +obj-y				+= osl.o utils.o reboot.o \

a one function C file? Can you just stick it in one of the other files
instead?

Greetings,
   Arjan van de Ven

