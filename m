Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbZCYJm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbZCYJm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbZCYJmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:42:20 -0400
Received: from fwtops.0.225.230.202.in-addr.arpa ([202.230.225.126]:47591 "EHLO
	topsms.toshiba-tops.co.jp" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751591AbZCYJmT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:42:19 -0400
Date: Wed, 25 Mar 2009 18:42:15 +0900 (JST)
Message-Id: <20090325.184215.229418774.nemoto@toshiba-tops.co.jp>
To: dan.j.williams@intel.com
Cc: maciej.sosnowski@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: Add privatecnt to revert DMA_PRIVATE propery
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <e9c3a7c20903161339o31470datdb2e82649a52bcf0@mail.gmail.com>
References: <1236337634-5110-1-git-send-email-anemo@mba.ocn.ne.jp>
	<e9c3a7c20903161339o31470datdb2e82649a52bcf0@mail.gmail.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.1 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009 13:39:49 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
> > Currently dma_request_channel() set DMA_PRIVATE capability but never
> > clear it.  So if a public channel was once grabbed by
> > dma_request_channel(), the device stay PRIVATE forever.  Add
> > privatecnt member to dma_device to correctly revert it.
> >
> > Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> > ---
> 
> This looks good to me.  Please rebase it on top of the 'next' branch
> of the async_tx tree[1] and I will queue it for -next.
> 
> Thanks,
> Dan
> 
> http://git.kernel.org/?p=linux/kernel/git/djbw/async_tx.git;a=shortlog;h=next

Sorry, I have missed this mail.  I will rebase it, but while the
'next' branch of async_tx tree lacks commit 287d85 ("atmel-mci: fix
initialization of dma slave data"), rebasing will cause another
conflict with mainline.  What should I do?

---
Atsushi Nemoto
