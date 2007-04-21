Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbXDUWuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbXDUWuc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 18:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbXDUWuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 18:50:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57665 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbXDUWub convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 18:50:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 1/8] Kconfig: refine depends statements.
Date: Sun, 22 Apr 2007 00:50:23 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       akpm@linux-foundation.org
References: <20070420113228.GB3738@skybase>
In-Reply-To: <20070420113228.GB3738@skybase>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704220050.24089.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/hPHZaYSj2p9n4t2pXG0dbCX1fCnOiR06lCWE
 QwCvGSRgCHKn6QeehA5FID7wuTo1ENcrkVqoo2v9jjf9EirxMn
 2LcVlXmq6njhe0Tk2w/3A==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 April 2007, Martin Schwidefsky wrote:
> diff -urpN linux-2.6/drivers/auxdisplay/Kconfig linux-2.6-patched/drivers/auxdisplay/Kconfig
> --- linux-2.6/drivers/auxdisplay/Kconfig        2007-04-19 15:23:55.000000000 +0200
> +++ linux-2.6-patched/drivers/auxdisplay/Kconfig        2007-04-19 15:49:17.000000000 +0200
> @@ -6,6 +6,7 @@
>  #
>  
>  menu "Auxiliary Display support"
> +       depends on PARPORT_PC
>  
>  config KS0108
>         tristate "KS0108 LCD Controller"

I would guess that this actually depends on PARPORT, not PARPORT_PC.

The rest of this patch looks good.

	Arnd <><
