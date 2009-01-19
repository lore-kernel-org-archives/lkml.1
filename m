Return-Path: <linux-kernel-owner+w=401wt.eu-S1757574AbZASSsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbZASSsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 13:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbZASSsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 13:48:05 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:17152 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbZASSsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 13:48:04 -0500
Message-ID: <4974CAD2.8050500@oracle.com>
Date: Mon, 19 Jan 2009 10:47:46 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>
Subject: Re: linux-next: Tree for January 19 (DST)
References: <20090119172732.e772d8ea.sfr@canb.auug.org.au> <4974C288.7030301@oracle.com> <20090119183046.GA28947@ioremap.net>
In-Reply-To: <20090119183046.GA28947@ioremap.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4974CAD6.003A:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> Hi Randy.
> 
> On Mon, Jan 19, 2009 at 10:12:24AM -0800, Randy Dunlap (randy.dunlap@oracle.com) wrote:
>>> There will be no build results for today's linux-next as our build server
>>> has failed.
>>>
>>> Changes since 20090116:
>>
>> DST build fails when CONFIG_BLOCK=n:
> 
> DST should depend on block and block device, in the original patch its
> kconfig entry was in the BLK_DEV menu, so this dependency was satisfied
> automatically. Should attached patch be pushed into drivers/staging?

Yes, thanks.
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> --- ./drivers/staging/dst/Kconfig~	2009-01-14 02:10:02.000000000 +0300
> +++ ./drivers/staging/dst/Kconfig	2009-01-19 21:31:19.000000000 +0300
> @@ -1,6 +1,6 @@
>  config DST
>  	tristate "Distributed storage"
> -	depends on NET && CRYPTO && SYSFS
> +	depends on NET && CRYPTO && SYSFS && BLK_DEV
>  	select CONNECTOR
>  	---help---
>  	DST is a network block device storage, which can be used to organize
> 


-- 
~Randy
