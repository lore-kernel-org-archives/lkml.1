Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbYHIOsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbYHIOsp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 10:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbYHIOsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 10:48:36 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:28241 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbYHIOsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 10:48:36 -0400
Date: Sat, 9 Aug 2008 16:48:29 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Seth Heasley <seth.heasley@intel.com>
Cc: linux-kernel@vger.kernel.org, i2c@lm-sensors.org
Subject: Re: [PATCH 2.6.26.2] i2c-i801: SMBus patch for Intel Ibex Peak
 DeviceIDs
Message-ID: <20080809164829.231c1d6f@hyperion.delvare>
In-Reply-To: <200808081602.28479.seth.heasley@intel.com>
References: <200808081602.28479.seth.heasley@intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth,

On Fri, 8 Aug 2008 16:02:28 -0700, Seth Heasley wrote:
> This patch adds the Intel Ibex Peak (PCH) SMBus Controller DeviceIDs.
> 
> Signed-off by: Seth Heasley <seth.heasley@intel.com>
> 
> --- linux-2.6.26.2/drivers/i2c/busses/i2c-i801.c.orig   2008-08-08 11:28:08.000000000 -0700
> +++ linux-2.6.26.2/drivers/i2c/busses/i2c-i801.c        2008-08-08 11:32:18.000000000 -0700
> @@ -43,6 +43,7 @@
>    Tolapai               0x5032     32     hard     yes     yes     yes
>    ICH10                 0x3a30     32     hard     yes     yes     yes
>    ICH10                 0x3a60     32     hard     yes     yes     yes
> +  PCH                   0x3b30     32     hard     yes     yes     yes
> 
>    Features supported by this driver:
>    Software PEC                     no
> @@ -592,6 +593,7 @@
>         { PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_TOLAPAI_1) },
>         { PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH10_4) },
>         { PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH10_5) },
> +       { PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PCH_2) },
>         { 0, }
>  };
> (...)

Your e-mail client converted all tabs to spaces, so your patch doesn't
apply. Please resend in a way which leaves the patch unmodified, so that I can apply it.

Thanks,
-- 
Jean Delvare
