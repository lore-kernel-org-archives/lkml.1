Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936008Ab0BZMfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:35:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54231
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935302Ab0BZMfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:35:18 -0500
Date: Fri, 26 Feb 2010 04:35:36 -0800 (PST)
Message-Id: <20100226.043536.63730567.davem@davemloft.net>
To: fujita.tomonori@lab.ntt.co.jp
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: use asm-generic/scatterlist.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100226093941C.fujita.tomonori@lab.ntt.co.jp>
References: <20100226093941C.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 26 Feb 2010 09:43:51 +0900

> sparc's scatterlist structure is identical to the generic one.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Applied, thank you.

BTW, the conditional sg_dma_len() definition cpp games done
in asm-generic/scatterlist.h might be superfluous these days.
