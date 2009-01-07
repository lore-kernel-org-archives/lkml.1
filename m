Return-Path: <linux-kernel-owner+w=401wt.eu-S1760148AbZAGSIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148AbZAGSIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 13:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbZAGSI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 13:08:29 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:43857 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbZAGSI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 13:08:28 -0500
Message-ID: <4964EF8D.7050803@oracle.com>
Date: Wed, 07 Jan 2009 10:08:13 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Tree for January 7 (ath9k)
References: <20090107170646.8d44292b.sfr@canb.auug.org.au>
In-Reply-To: <20090107170646.8d44292b.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4964EF93.00BC:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> The powerpc ppc44x_defconfig builds again.
> 
> Changes since 20090106:


drivers/built-in.o: In function `ath_detach':
main.c:(.text+0x16c6dc): undefined reference to `rfkill_unregister'
drivers/built-in.o: In function `ath_rfkill_poll':
main.c:(.text+0x16ce4e): undefined reference to `rfkill_force_state'
drivers/built-in.o: In function `ath9k_start':
main.c:(.text+0x16e034): undefined reference to `rfkill_register'
main.c:(.text+0x16e06d): undefined reference to `rfkill_free'
drivers/built-in.o: In function `ath_pci_probe':
main.c:(.text+0x16f9d1): undefined reference to `rfkill_allocate'

when CONFIG_RFKILL=n.


-- 
~Randy
