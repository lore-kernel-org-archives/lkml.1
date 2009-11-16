Return-Path: <linux-kernel-owner+w=401wt.eu-S1752161AbZKPDu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbZKPDu6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 22:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbZKPDu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 22:50:57 -0500
Received: from sh.osrg.net ([192.16.179.4]:53328 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbZKPDu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 22:50:57 -0500
Date: Mon, 16 Nov 2009 12:49:55 +0900
To: h-shimamoto@ct.jp.nec.com
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Don't put iommu_shutdown_noop() in init section
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4B00BC8E.50801@ct.jp.nec.com>
References: <4B00BC8E.50801@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091116124936K.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 16 Nov 2009 12:49:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Nov 2009 11:44:30 +0900
Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> It causes kernel panic on shutdown or reboot.
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  arch/x86/kernel/x86_init.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Duh, sorry about that.

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
