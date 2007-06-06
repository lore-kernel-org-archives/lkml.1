Return-Path: <linux-kernel-owner+w=401wt.eu-S1759154AbXFFGSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759154AbXFFGSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 02:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758680AbXFFGSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 02:18:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52392 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756923AbXFFGSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 02:18:00 -0400
Date: Tue, 5 Jun 2007 23:17:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jay Estabrook <jay.estabrook@hp.com>
Subject: Re: alpha compile failure (srm_printk)
Message-Id: <20070605231712.ff1df46f.akpm@linux-foundation.org>
In-Reply-To: <Pine.SOC.4.64.0706041419470.7370@math>
References: <Pine.SOC.4.64.0706041419470.7370@math>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007 14:21:25 +0300 (EEST) Meelis Roos <mroos@linux.ee> wrote:

> While trying make boot bootimage with 2.6.22-rc3 + todays git, the 
> compilation fails with
> 
>   CC      arch/alpha/boot/main.o
> arch/alpha/boot/main.c: In function 'load':arch/alpha/boot/main.c:135: warning: passing argument 3 of 'callback_read' makes pointer from integer without a cast
>   LD      arch/alpha/boot/bootloader
> arch/alpha/boot/bootloader.lds:25: undefined symbol `srm_printk' referenced in expression
> 
> This my first selfcompiled kernel for alpha so my config might be 
> faulty:

I was unable to repeoduce these errors on 2.6.22-rc4 with your config.

