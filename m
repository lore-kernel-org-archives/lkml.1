Return-Path: <linux-kernel-owner+w=401wt.eu-S1752054AbZH0O46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbZH0O46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 10:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbZH0O45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 10:56:57 -0400
Received: from mba.ocn.ne.jp ([122.28.14.163]:55412 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbZH0O45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 10:56:57 -0400
Date: Thu, 27 Aug 2009 23:52:00 +0900 (JST)
Message-Id: <20090827.235200.21363768.anemo@mba.ocn.ne.jp>
To: roel.kluin@gmail.com
Cc: wim@iguana.be, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] txx9wdt.c:52: Fix txx9wdt_probe() cleaning up after
 errors
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <4A93ACDA.8030000@gmail.com>
References: <4A93ACDA.8030000@gmail.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Aug 2009 11:20:26 +0200, Roel Kluin <roel.kluin@gmail.com> wrote:
> Make txx9wdt_probe() clean up after errors.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Any comments?

Well, why is this patch needed?  I intentionally omitted iounmap and
release_mem_region because devres guarantee these resources are freed
on probe failure.  Or are there any leaks?

---
Atsushi Nemoto
