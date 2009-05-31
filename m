Return-Path: <linux-kernel-owner+w=401wt.eu-S1752491AbZEaRXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbZEaRXl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 13:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbZEaRXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 13:23:34 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:52648 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbZEaRXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 13:23:34 -0400
Date: Mon, 01 Jun 2009 02:23:35 +0900 (JST)
Message-Id: <20090601.022335.200392387.anemo@mba.ocn.ne.jp>
To: mpm@selenic.com
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: [PATCH] TXx9: Add TX4939 RNG support
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <1243789289.22069.25.camel@calx>
References: <1243350141-883-2-git-send-email-anemo@mba.ocn.ne.jp>
	<20090601.015755.21367568.anemo@mba.ocn.ne.jp>
	<1243789289.22069.25.camel@calx>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 May 2009 12:01:29 -0500, Matt Mackall <mpm@selenic.com> wrote:
> > > Not clear to me how this works when this is a module?
> > 
> > This patch add a registration of a platform device for RNG to vmlinux.
> > And the other patch add a driver module for the RNG.  This strategy is
> > fairly common for SoCs or embedded platforms.
> 
> If your driver is built as a module (which your patch allows), the above
> won't work, right?

No, the rng driver can be used regardless of module or built-in, as
like as other platform drivers.  Any special issue for hw_rng?

---
Atsushi Nemoto
