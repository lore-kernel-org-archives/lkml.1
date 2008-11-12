Return-Path: <linux-kernel-owner+w=401wt.eu-S1752911AbYKLMg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbYKLMg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 07:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbYKLMgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 07:36:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:63477 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbYKLMgn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 07:36:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] ttusb-budget: make it depend on PCI
Date: Wed, 12 Nov 2008 13:35:59 +0100
User-Agent: KMail/1.9.9
Cc: v4l-dvb-maintainer@linuxtv.org, linux-dvb@linuxtv.org,
       Holger Waechtler <holger@convergence.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
References: <1226491218-9281-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1226491218-9281-1-git-send-email-vapier@gentoo.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200811121336.00521.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+GvvdwnqJQQQgy0/p+8tzA4jxRIaH0QcTar4h
 cRJXBrPB7CCevhmI9Jl0t1K3m1a8/dq9TKObCaIxCqiQm94CIs
 lFu6M1+YHoJObeq7x+3KA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 November 2008, Mike Frysinger wrote:
> From: 
> Mike Frysinger <vapier@gentoo.org>
>   To: 
> v4l-dvb-maintainer@linuxtv.org, linux-dvb@linuxtv.org, Holger Waechtler <holger@convergence.de>
>   CC: 
> Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org
>   Date: 
> Today 13:00:18
>    
> Since dvb-ttusb-budget.c relies on pci_alloc_consistent and
> pci_free_consistent, make it depend on PCI in Kconfig.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Shouldn't you just convert it (trivially) to dma_alloc_coherent and
dma_alloc_coherent?

	Arnd <><
