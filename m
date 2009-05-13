Return-Path: <linux-kernel-owner+w=401wt.eu-S1761848AbZEMVlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761848AbZEMVlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 17:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761628AbZEMVkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 17:40:42 -0400
Received: from mail-qy0-f133.google.com ([209.85.221.133]:46194 "EHLO
	mail-qy0-f133.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761618AbZEMVkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 17:40:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=HFOBS9XepXWf6F0mCWDMbai9rum5oDNu3rMemoCiqJq18oWhQuisuFYV0AfuAeCKi6
         aSunZ70DB4/MmukbrFT62D6NREWeekb7XVA28oZ05HbNKC1SXj8oY0knBvwRVviX6C5A
         Yb7qfO8GnhBzfNuEnTRux0ajgUDW+nYSuD5QU=
MIME-Version: 1.0
In-Reply-To: <1242249957-10352-1-git-send-email-galak@kernel.crashing.org>
References: <1242249957-10352-1-git-send-email-galak@kernel.crashing.org>
Date: Wed, 13 May 2009 14:40:41 -0700
X-Google-Sender-Auth: 968dbb0fae331440
Message-ID: <e9c3a7c20905131440n7a8c66a2j73997e44db7e4d97@mail.gmail.com>
Subject: Re: [PATCH] fsldma: Fix compile warnings
From: Dan Williams <dan.j.williams@intel.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 2:25 PM, Kumar Gala <galak@kernel.crashing.org> wrote:
> We we build with dma_addr_t as a 64-bit quantity we get:
>
> drivers/dma/fsldma.c: In function 'fsl_chan_xfer_ld_queue':
> drivers/dma/fsldma.c:625: warning: cast to pointer from integer of different size
> drivers/dma/fsldma.c: In function 'fsl_dma_chan_do_interrupt':
> drivers/dma/fsldma.c:737: warning: cast to pointer from integer of different size
> drivers/dma/fsldma.c:737: warning: cast to pointer from integer of different size
> drivers/dma/fsldma.c: In function 'of_fsl_dma_probe':
> drivers/dma/fsldma.c:927: warning: cast to pointer from integer of different
>
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>

Acked-by: Dan Williams <dan.j.williams@intel.com>

I'm fine with this going through your tree.

Thanks,
Dan
