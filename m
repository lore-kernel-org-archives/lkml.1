Return-Path: <linux-kernel-owner+w=401wt.eu-S1756451AbYIKNvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451AbYIKNvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 09:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755822AbYIKNuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 09:50:46 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:53052 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755706AbYIKNup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 09:50:45 -0400
Date: Thu, 11 Sep 2008 22:50:48 +0900 (JST)
Message-Id: <20080911.225048.25909971.anemo@mba.ocn.ne.jp>
To: david@fries.net
Cc: paul.gortmaker@gmail.com, akpm@linux-foundation.org, p_gortmaker@yahoo.com,
       alan@lxorguk.ukuu.org.uk, jeff@garzik.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] ne.c fix for hibernate and rmmod oops fix
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20080909025434.GB28469@spacedout.fries.net>
References: <20080904030212.GA23493@spacedout.fries.net>
	<7d1d9c250809050101v9ab3907l649781ee38a5a243@mail.gmail.com>
	<20080909025434.GB28469@spacedout.fries.net>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2008 21:54:34 -0500, David Fries <david@fries.net> wrote:
> Now that the io port and irq can be looked up in the arrays the probe
> code doesn't even need the resources passed by the platform device.
> The ne.c driver already registers the resources it needs and there
> isn't any good way to update the resources when the io port or irq are
> zero and probed at runtime.

No, please don't.  This breaks current users of ne platform driver.
For example, please look at rbtx4927_ne_init() in
arch/mips/txx9/rbtx4927/setup.c file.

---
Atsushi Nemoto
