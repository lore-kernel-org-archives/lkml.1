Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbZDGNRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbZDGNRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 09:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757900AbZDGNQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 09:16:23 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:57672 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757916AbZDGNQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:16:22 -0400
Date: Tue, 07 Apr 2009 22:16:28 +0900 (JST)
Message-Id: <20090407.221628.82355890.anemo@mba.ocn.ne.jp>
To: a.zummo@towertech.it
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc-tx4939: Drop IRQF_SHARED
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <1239036633-10032-3-git-send-email-anemo@mba.ocn.ne.jp>
References: <1239036633-10032-3-git-send-email-anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  7 Apr 2009 01:50:33 +0900, Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> IRQF_SHARED should be used with IRQF_DISABLED.  This RTC have dedicated
> irq line so there is no reason to use IRQF_SHARED.

Oops, the description was wrong: s/should be used/should not be used/.
I will resend with fixed description.

---
Atsushi Nemoto
