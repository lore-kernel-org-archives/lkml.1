Return-Path: <linux-kernel-owner+w=401wt.eu-S1761741AbZCPUkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761741AbZCPUkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 16:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758908AbZCPUjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 16:39:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:31989 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757878AbZCPUjv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 16:39:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Zn2yBl1HiU8L8os6QjXL6r1wCmPbdzcJyNdoNW6fvspf4WR+CNPgsBQlVG/w8uyxwb
         tm4x2khAdstS8uzfNNBd98lsOkSjonNrVEhdcAe9shMIdPJ14ZYgbw4runMC1ISz9NM4
         74+X16IdNVXf62uLlrdHLIbI3SeSuOvabZxok=
MIME-Version: 1.0
In-Reply-To: <1236337634-5110-1-git-send-email-anemo@mba.ocn.ne.jp>
References: <1236337634-5110-1-git-send-email-anemo@mba.ocn.ne.jp>
Date: Mon, 16 Mar 2009 13:39:49 -0700
X-Google-Sender-Auth: 542e7d63df8669cf
Message-ID: <e9c3a7c20903161339o31470datdb2e82649a52bcf0@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: Add privatecnt to revert DMA_PRIVATE propery
From: Dan Williams <dan.j.williams@intel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 6, 2009 at 4:07 AM, Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> Currently dma_request_channel() set DMA_PRIVATE capability but never
> clear it.  So if a public channel was once grabbed by
> dma_request_channel(), the device stay PRIVATE forever.  Add
> privatecnt member to dma_device to correctly revert it.
>
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> ---

This looks good to me.  Please rebase it on top of the 'next' branch
of the async_tx tree[1] and I will queue it for -next.

Thanks,
Dan

http://git.kernel.org/?p=linux/kernel/git/djbw/async_tx.git;a=shortlog;h=next
