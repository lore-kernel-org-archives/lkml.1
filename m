Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbYKVHzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbYKVHzl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 02:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbYKVHz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 02:55:29 -0500
Received: from rn-out-0910.google.com ([64.233.170.189]:24726 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbYKVHz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 02:55:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=tAxPr5r/DdAR1TYvYsraEi68cGdR1ulgsqHrH9uSPbjKNTeFx5EoeR95bCAMu1DfK3
         fhyClzFpdLzLUq3e/dLBzAy+K7NiJNpi4irn1GSBAjYhnwgl7NkxbQvixVrGAS7Zj8YP
         YheP3FB+qf25qGfklIRLoc5tFT/kCaFhpAXpI=
Message-ID: <9929d2390811212355j635e0e8iee0e53678efc5f09@mail.gmail.com>
Date: Fri, 21 Nov 2008 23:55:27 -0800
From: "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
To: "Qinghuang Feng" <qhfeng.kernel@gmail.com>
Subject: Re: [PATCH 1/3] driver/net/*: remove redundant argument comments
Cc: "David Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4927b790.0e0d6e0a.65cc.ffffcb05@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4927b790.0e0d6e0a.65cc.ffffcb05@mx.google.com>
X-Google-Sender-Auth: e2394a3d301b35bd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 11:40 PM, Qinghuang Feng
<qhfeng.kernel@gmail.com> wrote:
> remove redundant argument comments in files of drivers/net/*
>
> Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
> ---
> diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
> index 91795f7..122539a 100644
> --- a/drivers/net/e1000e/netdev.c
> +++ b/drivers/net/e1000e/netdev.c
> @@ -345,7 +345,6 @@ no_buffers:
>  /**
>  * e1000_alloc_jumbo_rx_buffers - Replace used jumbo receive buffers
>  * @adapter: address of board private structure
> - * @rx_ring: pointer to receive ring structure
>  * @cleaned_count: number of buffers to allocate this pass
>  **/
>

NAK - rather than removing documentation, I would suggest improving
the documentation.  Your suggested patch removes lines in the function
headers which can be (if not already) in documentation.  Specifically,
the function header comments for Intel drivers was written in such a
way that it can be parsed out by the kernel documentation scripts to
create an API document.

I would agree that "@rx_ring: pointer to receive ring structure" is
probably not the best documentation, but rather than removing it, I
would suggest improving it.


-- 
Cheers,
Jeff
