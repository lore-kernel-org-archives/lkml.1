Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbYLPM0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbYLPM0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 07:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbYLPM0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 07:26:11 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55568 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbYLPM0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 07:26:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: JosephChan@via.com.tw
Subject: Re: [Patch 3/3] via-sdmmc: via-sdmmc.h
Date: Tue, 16 Dec 2008 13:25:58 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB808520F3C@exchtp03.taipei.via.com.tw>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB808520F3C@exchtp03.taipei.via.com.tw>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812161325.58594.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19bdJUk0AGf3kenI2m+1QixIxNLqdP5+Xy8tKf
 ERbQtWi6eXbItNP00T3mV8/JHeeJkeS8BV9239ITAGtdcihzXr
 8nEsQdfJeBr0JkYMAiF/g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 December 2008, JosephChan@via.com.tw wrote:
> Header file of VIA MSP SD/MMC card reader driver.
> 

The order of your patches is reversed, you add the Kconfig/Makefile
changes last so that the tree stays 'bisectable', i.e. you don't
have a broken build in the middle between your patches.

Since your header file is not an interface but only used in a single
source file, I would also suggest merging it into the main via-sdmmc.c
file, add changing Kconfig/Makefile in the same patch.

	Arnd <><
