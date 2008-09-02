Return-Path: <linux-kernel-owner+w=401wt.eu-S1751890AbYIBMEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbYIBMEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 08:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbYIBMEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 08:04:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:63309 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbYIBMEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 08:04:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Li Yang <leoli@freescale.com>
Subject: Re: [PATCH v3] usb: add Freescale QE/CPM USB peripheral controller driver
Date: Tue, 2 Sep 2008 14:01:24 +0200
User-Agent: KMail/1.9.9
Cc: greg@kroah.com, linux-usb@vger.kernel.org, dbrownell@users.sourceforge.net,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       avorontsov@ru.mvista.com
References: <1220356690-8028-1-git-send-email-leoli@freescale.com>
In-Reply-To: <1220356690-8028-1-git-send-email-leoli@freescale.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809021401.25506.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+ps6YcVnzZfPpcjjj0zuLvsnOeZZ2fJOG0LQO
 1feKBD6YkAn7/QPkLeHW1+MDAb1SyQNE0QuRTAJnQFNoIRb6QI
 3zo83sa0u8Fruma6COOOg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 September 2008, Li Yang wrote:
> Some of Freescale SoC chips have a QE or CPM co-processor which
> supports full speed USB.  The driver adds device mode support
> of both QE and CPM USB controller to Linux USB gadget.  The
> driver is tested with MPC8360 and MPC8272, and should work with
> other models having QE/CPM given minor tweaks.
> 
> Signed-off-by: Xie Xiaobo <X.Xie@freescale.com>
> Signed-off-by: Li Yang <leoli@freescale.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

All my previous review comments have been addressed.

> +	udc_controller->soc_type = (unsigned long)np->data;

I'm not sure about this line, shouldn't that be
	udc_controller->soc_type = (unsigned long)match->data; ?

	Arnd <><
