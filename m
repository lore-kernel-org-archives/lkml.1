Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab0AOSPz (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 13:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757961Ab0AOSPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 13:15:54 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:50878 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757941Ab0AOSPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 13:15:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=juBmlhV95IrOtm6JXl9vPvik2CSi+FNa7YddmWNXH1Lt69rB9kighd5mvuz0+PQOfR8w8hbcCjuWeCiPMlW12TQChmGSEe8y5K/NtdCVztbavxeC4hnJFTiK1Bfyrg+1;
Date: Fri, 15 Jan 2010 10:15:54 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Seth Heasley <seth.heasley@intel.com>
Cc: linux-kernel@vger.kernel.org, khali@linux-fr.org, i2c@lm-sensors.org,
        linux-pci@vger.kernel.org, seth.heasley@intel.com,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
Subject: Re: [PATCH 2.6.32.3] i2c-i801: SMBus patch for Intel Cougar Point
 DeviceIDs
Message-ID: <20100115101554.2881950f@jbarnes-piketon>
In-Reply-To: <201001121658.54044.seth.heasley@intel.com>
References: <201001121658.54044.seth.heasley@intel.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems like Jean or Ben should take this.

Jesse

On Tue, 12 Jan 2010 16:58:53 -0800
Seth Heasley <seth.heasley@intel.com> wrote:

> This patch adds the Intel Cougar Point (PCH) SMBus Controller
> DeviceIDs.
> 
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
> 
> --- linux-2.6.32.3/drivers/i2c/busses/i2c-i801.c.orig
> 2010-01-06 15:07:45.000000000 -0800 +++
> linux-2.6.32.3/drivers/i2c/busses/i2c-i801.c	2010-01-07
> 13:10:28.000000000 -0800 @@ -41,7 +41,8 @@ Tolapai
> 0x5032     32     hard     yes     yes     yes ICH10
> 0x3a30     32     hard     yes     yes     yes ICH10
> 0x3a60     32     hard     yes     yes     yes
> -  PCH                   0x3b30     32     hard     yes     yes
> yes
> +  3400/5 Series (PCH)   0x3b30     32     hard     yes     yes
> yes
> +  CPT                   0x1c22     32     hard     yes     yes
> yes 
>    Features supported by this driver:
>    Software PEC                     no
> @@ -578,6 +579,7 @@
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL,
> PCI_DEVICE_ID_INTEL_ICH10_4) }, { PCI_DEVICE(PCI_VENDOR_ID_INTEL,
> PCI_DEVICE_ID_INTEL_ICH10_5) }, { PCI_DEVICE(PCI_VENDOR_ID_INTEL,
> PCI_DEVICE_ID_INTEL_PCH_SMBUS) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL,
> PCI_DEVICE_ID_INTEL_CPT_SMBUS) }, { 0, }
>  };
>  
> @@ -707,6 +709,7 @@
>  	case PCI_DEVICE_ID_INTEL_ICH10_4:
>  	case PCI_DEVICE_ID_INTEL_ICH10_5:
>  	case PCI_DEVICE_ID_INTEL_PCH_SMBUS:
> +	case PCI_DEVICE_ID_INTEL_CPT_SMBUS:
>  		i801_features |= FEATURE_I2C_BLOCK_READ;
>  		/* fall through */
>  	case PCI_DEVICE_ID_INTEL_82801DB_3:
> --- linux-2.6.32.3/drivers/i2c/busses/Kconfig.orig	2010-01-06
> 15:07:45.000000000 -0800 +++
> linux-2.6.32.3/drivers/i2c/busses/Kconfig	2010-01-07
> 13:10:28.000000000 -0800 @@ -98,6 +98,7 @@ Tolapai
>  	    ICH10
>  	    PCH
> +	    CPT
>  
>  	  This driver can also be built as a module.  If so, the
> module will be called i2c-i801.
> 


-- 
Jesse Barnes, Intel Open Source Technology Center
