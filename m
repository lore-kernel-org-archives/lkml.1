Return-Path: <linux-kernel-owner+w=401wt.eu-S1763507AbZCYQ1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763507AbZCYQ1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758427AbZCYQ1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:27:30 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:23454 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747AbZCYQ13 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:27:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fzHH/eYhIm1/zU9LqODFt9dbj8mb5P0B0xJh9z4YPPQpAb5BKTkqi/6Mcaz2TPknuX
         4KvFjeVdHn2Gf8OstZ5XylZ8bd262sUG84sp255J2TTx0AyBTwOCnLUANT0XuVOxW/Tk
         olC9O2bLigDnKd6Wl+MBN+1LYok5XZx/rrBzs=
MIME-Version: 1.0
In-Reply-To: <20090325.184215.229418774.nemoto@toshiba-tops.co.jp>
References: <1236337634-5110-1-git-send-email-anemo@mba.ocn.ne.jp>
	 <e9c3a7c20903161339o31470datdb2e82649a52bcf0@mail.gmail.com>
	 <20090325.184215.229418774.nemoto@toshiba-tops.co.jp>
Date: Wed, 25 Mar 2009 09:27:27 -0700
X-Google-Sender-Auth: a193bfa3eede67b4
Message-ID: <e9c3a7c20903250927iea1a4b1h1041deee251e4e5f@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: Add privatecnt to revert DMA_PRIVATE propery
From: Dan Williams <dan.j.williams@intel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: maciej.sosnowski@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 2:42 AM, Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> On Mon, 16 Mar 2009 13:39:49 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
>> > Currently dma_request_channel() set DMA_PRIVATE capability but never
>> > clear it.  So if a public channel was once grabbed by
>> > dma_request_channel(), the device stay PRIVATE forever.  Add
>> > privatecnt member to dma_device to correctly revert it.
>> >
>> > Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
>> > ---
>>
>> This looks good to me.  Please rebase it on top of the 'next' branch
>> of the async_tx tree[1] and I will queue it for -next.
>>
>> Thanks,
>> Dan
>>
>> http://git.kernel.org/?p=linux/kernel/git/djbw/async_tx.git;a=shortlog;h=next
>
> Sorry, I have missed this mail.  I will rebase it, but while the
> 'next' branch of async_tx tree lacks commit 287d85 ("atmel-mci: fix
> initialization of dma slave data"), rebasing will cause another
> conflict with mainline.  What should I do?

I have updated the 'next' branch to include this commit.

Thanks,
Dan
