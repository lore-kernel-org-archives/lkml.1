Return-Path: <linux-kernel-owner+w=401wt.eu-S1762522AbZD1P5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762522AbZD1P5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761518AbZD1P4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:56:48 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:64595 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761690AbZD1P4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:56:47 -0400
Date: Wed, 29 Apr 2009 00:56:50 +0900 (JST)
Message-Id: <20090429.005650.95062036.anemo@mba.ocn.ne.jp>
To: hans-christian.egtvedt@atmel.com
Cc: alessandro.zummo@towertech.it, rtc-linux@googlegroups.com,
       david-b@pacbell.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, hcegtvedt@atmel.com, vapier@gentoo.org,
       rongkai.zhan@windriver.com, balajirrao@openmoko.org,
       broonie@opensource.wolfsonmicro.com
Subject: Re: [rtc-linux] Re: [PATCH] rtc: Make rtc_update_irq callable with
 irqs enabled
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20090428151353.0c15c5fc@hcegtvedt.norway.atmel.com>
References: <20090425.014850.93020801.anemo@mba.ocn.ne.jp>
	<20090425.020612.92585418.anemo@mba.ocn.ne.jp>
	<20090428151353.0c15c5fc@hcegtvedt.norway.atmel.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009 15:13:53 +0200, Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com> wrote:
> AVR32 has interrupts disabled during the interrupt handler, so AFAICT
> the rtc-at32ap700x.c should be fine.

If IRQF_DISABLED was not set, handle_IRQ_event() enables interrupts
on AVR32, as well as other archs, no?

Anyway rtc-at32ap700x uses only one interrupt so there should be no
real problem.

---
Atsushi Nemoto
