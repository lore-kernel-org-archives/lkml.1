Return-Path: <linux-kernel-owner+w=401wt.eu-S932878AbZAOVw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878AbZAOVw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbZAOVwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 16:52:36 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:57358 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758084AbZAOVwe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 16:52:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] mmc: Add driver for Freescale eSDHC controllers
Date: Thu, 15 Jan 2009 22:52:31 +0100
User-Agent: KMail/1.9.9
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Konjin Lai <Konjin.Lai@freescale.com>, linux-kernel@vger.kernel.org,
       Xie Xiaobo <X.Xie@freescale.com>,
       "Joe D'Abbraccio" <Joe.D'abbraccio@freescale.com>
References: <20090114194631.GA25978@oksana.dev.rtsoft.ru>
In-Reply-To: <20090114194631.GA25978@oksana.dev.rtsoft.ru>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901152252.32480.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18x5GrwR5ZN5XyaKT8ppIS3iAF+0o6Xy2yDDxD
 Wj/zozZ6Df1qpIjDgz1XdMU+3QrRoFZok1NQ1pBRlL4czM30fQ
 g0G2lZpbIT4rWY1bcLxzw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 January 2009, Anton Vorontsov wrote:
> 
> +config MMC_ESDHC
> +       tristate "Freescale Enhanced SD Host Controller Interface support"
> +       depends on FSL_SOC
> +       help
> +         This selects the Freescale Enhanced SD Host Controller Interface
> +         as found in some Freescale PowerPC microprocessors.
> +
> +         If unsure, say N.


The naming could be improved, calling it ESDHC instead of ESDHCI is very
confusing: SDHCI is the controller chip while SDHC is a type of card (high
capacity SD). This driver clearly does not refer to the card type but
rather to the controller.

	Arnd <><
