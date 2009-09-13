Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbZIMOZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbZIMOZx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 10:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbZIMOZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 10:25:48 -0400
Received: from mba.ocn.ne.jp ([122.28.14.163]:63957 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958AbZIMOZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 10:25:48 -0400
Date: Sun, 13 Sep 2009 23:25:48 +0900 (JST)
Message-Id: <20090913.232548.253168283.anemo@mba.ocn.ne.jp>
To: julia@diku.dk
Cc: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/8] arch/mips/txx9: introduce missing kfree, iounmap
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <Pine.LNX.4.64.0909111820370.10552@pc-004.diku.dk>
References: <Pine.LNX.4.64.0909111820370.10552@pc-004.diku.dk>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Sep 2009 18:21:00 +0200 (CEST), Julia Lawall <julia@diku.dk> wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Error handling code following a kzalloc should free the allocated data.
> Error handling code following an ioremap should iounmap the allocated data.
> 
> The semantic match that finds the first problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)

Thank you for finding this out.

This patch add some correctness, but obviously incomplete: there are
more error pathes without iounmap/kfree/etc. in this function.

And I like goto-style cleanup, as Mark Brown said in reply for your
sound/soc patch.

Could you make a new patch?

---
Atsushi Nemoto
