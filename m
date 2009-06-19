Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbZFSOFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbZFSOFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 10:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZFSOFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 10:05:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:56478 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbZFSOFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 10:05:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Florian Fainelli <florian@openwrt.org>
Subject: Re: [PATCH] [x86] rdc321x: select EMBEDDED
Date: Fri, 19 Jun 2009 16:02:36 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
References: <200906191548.27101.florian@openwrt.org>
In-Reply-To: <200906191548.27101.florian@openwrt.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200906191602.36711.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19FAVKqg6h26ots7IuoL8/65byFnADg1A2RAPo
 6WJb3wNXxfG58xoius+IsC12yeH2BRc71RCbPggzfY9BO2MOqh
 pkw4YIghorXQ1Fpc1yv8Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 June 2009, Florian Fainelli wrote:
> The RDC321X SoC is used in embedded systems, select
> the EMBEDDED configuration symbol to set options
> accordingly.
> 
> Signed-off-by: Florian Fainelli <florian@openwrt.org>

This is not what CONFIG_EMBEDDED means (strictly),
the only thing that option does is to give you more
choice of which kernel features to enable to disable.

I suppose what you want is an rdc321x_defconfig file
that sets CONFIG_EMBEDDED and then sets up whatever
optional features you want.

	Arnd <><
