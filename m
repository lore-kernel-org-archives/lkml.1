Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbZFBONT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbZFBONT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbZFBONM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:13:12 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:61687 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753AbZFBONM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:13:12 -0400
Date: Tue, 02 Jun 2009 23:13:11 +0900 (JST)
Message-Id: <20090602.231311.106274589.anemo@mba.ocn.ne.jp>
To: mpm@selenic.com
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: [PATCH] TXx9: Add TX4939 RNG support
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <1243791170.22069.28.camel@calx>
References: <1243789289.22069.25.camel@calx>
	<20090601.022335.200392387.anemo@mba.ocn.ne.jp>
	<1243791170.22069.28.camel@calx>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 May 2009 12:32:50 -0500, Matt Mackall <mpm@selenic.com> wrote:
> > No, the rng driver can be used regardless of module or built-in, as
> > like as other platform drivers.  Any special issue for hw_rng?
> 
> I found the source of my confusion: you've given the init function in
> both files exactly the same name. So when I saw .._init at the bottom of
> the second patch, I assumed it was referring to the possibly not loaded
> driver's init code.

OK, I see.  I will rename one of them to avoid such a confusion.
Thanks.

---
Atsushi Nemoto
