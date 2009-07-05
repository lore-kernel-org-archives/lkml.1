Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbZGETRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbZGETRe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 15:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbZGETR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 15:17:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49497 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbZGETR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 15:17:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 0/3] dma-mapping:remove CONFIG_HAVE_DMA_ATTRS
Date: Sun, 5 Jul 2009 21:17:16 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.30-10-generic; KDE/4.2.95; x86_64; ; )
Cc: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <1246674895-9610-1-git-send-email-tom.leiming@gmail.com> <200907051319.37169.arnd@arndb.de> <20090705204418.44fc38c1@linux-lm>
In-Reply-To: <20090705204418.44fc38c1@linux-lm>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907052117.16308.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18nTQ4HDLZQoMdnvZ2zqt36mI4hgT4QLbfVpfa
 IyMuCbNIhL9IlVJupDrVYaViVtqqx56+bKniszO2ILsPWjAtOS
 XlRPSetNy+TyWdh7iTisA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 July 2009, Ming Lei wrote:
> If a new arch does not define CONFIG_HAVE_DMA_ATTRS but uses
> dma-mapping-common.h, it will lead to a compile failure. 

Right, but I think we should just mandate that every arch that wants
to use dma-mapping-common.h should define CONFIG_HAVE_DMA_ATTRS,
which is sort of implied by the definition of dma_map_ops anyway.

	Arnd <><
