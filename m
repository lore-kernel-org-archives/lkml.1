Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbYKLNx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbYKLNx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 08:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbYKLNxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 08:53:14 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:53821 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbYKLNxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 08:53:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] ttusb-budget: make it depend on PCI
Date: Wed, 12 Nov 2008 14:46:59 +0100
User-Agent: KMail/1.9.9
Cc: Mike Frysinger <vapier@gentoo.org>, v4l-dvb-maintainer@linuxtv.org,
       linux-dvb@linuxtv.org, Holger Waechtler <holger@convergence.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
References: <1226491218-9281-1-git-send-email-vapier@gentoo.org> <200811121336.00521.arnd@arndb.de> <874p2ddr72.fsf@basil.nowhere.org>
In-Reply-To: <874p2ddr72.fsf@basil.nowhere.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811121447.00808.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19dXaET15Wm0vfCE3aLUse/SFfRuYUHbJChHNE
 SZT6a50w16nqCx6CTgixq7LpRA8rWrQ7bMfX6PXDpOvQhTfj7c
 TWerx4bHVEAej6knlC1VA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 November 2008, Andi Kleen wrote:
> Unless it really needs to use the 16MB DMA zone (which I doubt
> especially for USB devices) then it should not call either with a NULL
> device argument.

Yes, of course. It will need to pass &ttusb->dev.dev to dma_alloc_coherent.

	Arnd <><

---

Note to self: read code before commenting on it...
