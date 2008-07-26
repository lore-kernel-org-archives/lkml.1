Return-Path: <linux-kernel-owner+w=401wt.eu-S1755665AbYGZOoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbYGZOoo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 10:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbYGZOoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 10:44:37 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:57889 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbYGZOog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 10:44:36 -0400
Date: Sat, 26 Jul 2008 23:46:29 +0900 (JST)
Message-Id: <20080726.234629.72707418.anemo@mba.ocn.ne.jp>
To: geert@linux-m68k.org
Cc: ralf@linux-mips.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       linux-arch@vger.kernel.org
Subject: Re: [patch 29/29] initrd: Fix virtual/physical mix-up in overwrite
 test
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <Pine.LNX.4.64.0807252104460.11082@anakin>
References: <Pine.LNX.4.64.0807242032430.701@anakin>
	<20080726.012731.122621958.anemo@mba.ocn.ne.jp>
	<Pine.LNX.4.64.0807252104460.11082@anakin>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 21:22:20 +0200 (CEST), Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> So there's definitely room for a small janitors project...
> 
> Probably the best short term solution is to make mips' virt_to_page()
> cast to `unsigned long' internally, like the other platforms.
>
> Alternatively, you can try the patch below (compile-tested on mips :-),
> which does add a cast to the generic code.

Thanks, I prefer this one for short term solution, while I think
explicit argument type would be better in general.

---
Atsushi Nemoto
