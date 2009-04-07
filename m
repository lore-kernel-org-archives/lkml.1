Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbZDGMmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbZDGMmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 08:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbZDGMm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 08:42:29 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:54666 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbZDGMm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 08:42:28 -0400
Date: Tue, 07 Apr 2009 21:42:32 +0900 (JST)
Message-Id: <20090407.214232.07643613.anemo@mba.ocn.ne.jp>
To: alessandro.zummo@towertech.it
Cc: rtc-linux@googlegroups.com, a.zummo@towertech.it,
       linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] [PATCH] rtc-tx4939: Drop IRQF_SHARED
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20090406191053.740229a8@i1501.lan.towertech.it>
References: <1239036633-10032-3-git-send-email-anemo@mba.ocn.ne.jp>
	<20090406191053.740229a8@i1501.lan.towertech.it>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009 19:10:53 +0200, Alessandro Zummo <alessandro.zummo@towertech.it> wrote:
> > IRQF_SHARED should be used with IRQF_DISABLED.  This RTC have dedicated
> > irq line so there is no reason to use IRQF_SHARED.
> 
>  Is that true for every board this rtc is/will be used on?

Yes.  This RTC is internal device of TX4939 SoC and its irq line is
hardwired to SoC's interrupt controller.  At least TX4939 uses
dedicated irq number for the RTC and I believe all future SoC (if
possible) will follow.

---
Atsushi Nemoto
