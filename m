Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbZCZLoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbZCZLoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 07:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbZCZLoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 07:44:11 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:53442 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbZCZLoK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 07:44:10 -0400
Date: Thu, 26 Mar 2009 20:44:16 +0900 (JST)
Message-Id: <20090326.204416.65192110.anemo@mba.ocn.ne.jp>
To: dan.j.williams@intel.com
Cc: maciej.sosnowski@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: Add privatecnt to revert DMA_PRIVATE propery
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <e9c3a7c20903250927iea1a4b1h1041deee251e4e5f@mail.gmail.com>
References: <e9c3a7c20903161339o31470datdb2e82649a52bcf0@mail.gmail.com>
	<20090325.184215.229418774.nemoto@toshiba-tops.co.jp>
	<e9c3a7c20903250927iea1a4b1h1041deee251e4e5f@mail.gmail.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Mar 2009 09:27:27 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
> >> > Currently dma_request_channel() set DMA_PRIVATE capability but never
> >> > clear it.  So if a public channel was once grabbed by
> >> > dma_request_channel(), the device stay PRIVATE forever.  Add
> >> > privatecnt member to dma_device to correctly revert it.
> >> >
> >> > Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> >>
> >> This looks good to me.  Please rebase it on top of the 'next' branch
> >> of the async_tx tree[1] and I will queue it for -next.
> >>
> > Sorry, I have missed this mail.  I will rebase it, but while the
> > 'next' branch of async_tx tree lacks commit 287d85 ("atmel-mci: fix
> > initialization of dma slave data"), rebasing will cause another
> > conflict with mainline.  What should I do?
> 
> I have updated the 'next' branch to include this commit.

Thanks.  And now the patch can be applied using git-am as is.
Should I rebase and send again?

---
Atsushi Nemoto
