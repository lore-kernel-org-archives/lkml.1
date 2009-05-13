Return-Path: <linux-kernel-owner+w=401wt.eu-S1759556AbZEMKjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbZEMKjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 06:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756666AbZEMKjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 06:39:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53687 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248AbZEMKja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 06:39:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Brad Boyer <flar@allandria.com>
Subject: Re: [PATCH] ata: libata depends on HAS_DMA
Date: Wed, 13 May 2009 12:39:00 +0200
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       takata@linux-m32r.org, geert@linux-m68k.org, linux-m68k@vger.kernel.org,
       ysato@users.sourceforge.jp
References: <20090511222702.352192505@arndb.de> <200905121123.21436.arnd@arndb.de> <20090513033027.GA13193@cynthia.pants.nu>
In-Reply-To: <20090513033027.GA13193@cynthia.pants.nu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905131239.01677.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19Ds4JXSrNukvENzVkO/SuveUADxkNFyZGewxs
 YAri8H36zTlmyvTV71/Ir7yq0QPsh+rahuwNnVlONicbcwLzbA
 ctyFL0HiBTjhfxBWfzdNw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 May 2009, Brad Boyer wrote:
> If I'm reading the m68k code correctly, SUN3 is the one that doesn't have
> DMA. It is implemented on any m68k with a standard Motorola MMU. It might
> be possible to get the DMA code working on a sun3, but I doubt they ever
> have IDE hardware.

Yes, that's right, I misread the Kconfig logic.

In m68nommu, there are also Dragonball and MC68360 that are supported
but don't support the DMA API right now. Is that a real limitation, or
could those potentially have ATA ports?

	Arnd <><
