Return-Path: <linux-kernel-owner+w=401wt.eu-S1759565AbZAWBMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565AbZAWBMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:12:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbZAWBMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:12:36 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:64518 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbZAWBMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:12:35 -0500
Message-ID: <49791978.8080709@oracle.com>
Date: Thu, 22 Jan 2009 17:12:24 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Nico Schottelius <nico-linux-20090121@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29-rc2: drivers/mfd/pcf50633-core.ko has undefined symbols
References: <20090121114432.GA4590@denkbrett.schottelius.org>
In-Reply-To: <20090121114432.GA4590@denkbrett.schottelius.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4979197B.0264:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nico Schottelius wrote:
> Hello!
> 
> When trying to compile latest kernel from linux-2.6 or iwlwifi I get:
> 
> CRC e950f5f4
> Kernel: arch/x86/boot/bzImage is ready  (#7)
>   Building modules, stage 2.
>   MODPOST 1666 modules
> ERROR: "__set_irq_handler" [drivers/mfd/pcf50633-core.ko] undefined!
> ERROR: "handle_level_irq" [drivers/mfd/pcf50633-core.ko] undefined!
> make[1]: *** [__modpost] Fehler 1
> make: *** [modules] Fehler 2
> 
> Kernels tested:
> 
>   v2.6.29-rc2 (git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git)
>   v2.6.29-rc2-27573-g599c546 (git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git)
> 
> .config is attached from v2.6.29-rc2.

Patch is available & pull request has been sent to Linus, but he is
traveling/at a conference/not merging patches at the moment.

-- 
~Randy
