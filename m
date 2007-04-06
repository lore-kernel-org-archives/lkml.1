Return-Path: <linux-kernel-owner+w=401wt.eu-S1767585AbXDFLKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767585AbXDFLKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 07:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbXDFLKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 07:10:37 -0400
Received: from www.osadl.org ([213.239.205.134]:37657 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752648AbXDFLKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 07:10:37 -0400
From: =?utf-8?q?Hans-J=C3=BCrgen_Koch?= <hjk@linutronix.de>
Organization: Linutronix
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [-mm patch] drivers/uio/uio_cif.c: convert pci_module_init()
Date: Fri, 6 Apr 2007 13:11:56 +0200
User-Agent: KMail/1.9.5
Cc: Greg Kroah-Hartman <gregkh@suse.de>, tglx@linutronix.de,
       Benedikt Spranger <b.spranger@linutronix.de>,
       linux-kernel@vger.kernel.org
References: <20070406101937.GD29169@stusta.de>
In-Reply-To: <20070406101937.GD29169@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704061311.57723.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 06 April 2007 12:19 schrieb Adrian Bunk:
> This patch converts the pci_module_init() usage to pci_register_driver().
>
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
>
> ---
> --- linux-2.6.21-rc5-mm4/drivers/uio/uio_cif.c.old	2007-04-05
> 20:44:24.000000000 +0200 +++
> linux-2.6.21-rc5-mm4/drivers/uio/uio_cif.c	2007-04-05 20:44:38.000000000
> +0200 @@ -144,7 +144,7 @@
>
>  static int __init hilscher_init_module(void)
>  {
> -	return pci_module_init(&hilscher_pci_driver);
> +	return pci_register_driver(&hilscher_pci_driver);
>  }
>
>  static void __exit hilscher_exit_module(void)

OK.

Acked-by: Hans J. Koch <hjk@linutronix.de>

