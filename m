Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab0BRSUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:20:17 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:38461 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab0BRSUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:20:14 -0500
Message-ID: <4B7D8200.3000902@oracle.com>
Date: Thu, 18 Feb 2010 10:08:00 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Denis Turischev <denis@compulab.co.il>
CC: LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v3 1/3] MFD: introduce lpc_sch for Intel SCH LPC bridge
References: <4B73DAEE.5080400@compulab.co.il> <4B73DB4B.40501@compulab.co.il> <4B7D7C13.20703@compulab.co.il> <4B7D7CD0.7080202@oracle.com> <4B7D807D.9060105@compulab.co.il>
In-Reply-To: <4B7D807D.9060105@compulab.co.il>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B7D820D.002F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/10 10:01, Denis Turischev wrote:
> Intel Poulsbo (SCH) chipset LPC bridge controller contains several
> functions. Creating and MFD driver for the LPC bridge controller allows
> simultaneous use of SMBus and GPIO interfaces on the SCH.
> 
> v2: added "select MFD_CORE"
> v3: removed "default m"

Thanks.


> Signed-off-by: Denis Turischev <denis@compulab.co.il>
> 
> diff -Nru linux-2.6.33-rc7.orig/drivers/mfd/Kconfig
> linux-2.6.33-rc7/drivers/mfd/Kconfig
> --- linux-2.6.33-rc7.orig/drivers/mfd/Kconfig    2010-02-07
> 00:17:12.000000000 +0200
> +++ linux-2.6.33-rc7/drivers/mfd/Kconfig    2010-02-18
> 19:56:19.000000000 +0200
> @@ -348,6 +348,14 @@
>        read/write functions for the devices to get access to this chip.
>        This chip embeds various other multimedia funtionalities as well.
> 
> +config LPC_SCH
> +    tristate "Intel SCH LPC"
> +    depends on PCI
> +    select MFD_CORE
> +    help
> +      LPC bridge function of the Intel SCH provides support for
> +      System Management Bus and General Purpose I/O.
> +
>  endmenu
> 
>  menu "Multimedia Capabilities Port drivers"


-- 
~Randy
