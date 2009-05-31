Return-Path: <linux-kernel-owner+w=401wt.eu-S1759524AbZEaRST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524AbZEaRST (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 13:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbZEaRSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 13:18:09 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:57099 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122AbZEaRSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 13:18:08 -0400
Date: Mon, 01 Jun 2009 02:18:07 +0900 (JST)
Message-Id: <20090601.021807.250571902.anemo@mba.ocn.ne.jp>
To: mpm@selenic.com
Cc: akpm@linux-foundation.org, linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: [PATCH] hwrng: Add TX4939 RNG driver
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <1243789210.22069.23.camel@calx>
References: <20090529162907.9cb1bba2.akpm@linux-foundation.org>
	<20090601.014517.169682203.anemo@mba.ocn.ne.jp>
	<1243789210.22069.23.camel@calx>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 May 2009 12:00:09 -0500, Matt Mackall <mpm@selenic.com> wrote:
> > >From the datasheet:
> > 
> > 	The quality of the random numbers generated immediately after
> > 	reset can be insufficient.  Therefore, do not use random
> > 	numbers obtained from the first and second generations; use
> > 	the ones from the third or subsequent generation.
> 
> Does the datasheet say anything about -how- the random numbers are
> produced? Most physical sources that I'm aware of don't have this sort
> of issue. But some pseudo-RNGs do. So this looks a little worrisome.

Nothing for "how".  If a RNG was actually a pseudo-RNG, does anything
a driver should do?  Any future plan to select one RNG from multiple
sources based on randomness grade?

---
Atsushi Nemoto
