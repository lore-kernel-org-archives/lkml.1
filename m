Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714Ab0BCR06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 12:26:58 -0500
Received: from are.twiddle.net ([75.149.56.221]:56953 "EHLO are.twiddle.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932688Ab0BCR0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 12:26:55 -0500
X-Greylist: delayed 614 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Feb 2010 12:26:55 EST
Message-ID: <4B69AF72.3000208@twiddle.net>
Date: Wed, 03 Feb 2010 09:16:34 -0800
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] alpha: PTR_ERR overwrites -EINVAL in syscall osf_mount
References: <4B699B06.2040202@gmail.com>
In-Reply-To: <4B699B06.2040202@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2010 07:49 AM, Roel Kluin wrote:
> The initial -EINVAL value is overwritten by `retval = PTR_ERR(name)'.
> If this isn't an error pointer and typenr is not 1, 6 or 9, then
> this retval, a pointer cast to a long, is returned.
>
> Signed-off-by: Roel Kluin<roel.kluin@gmail.com>

Acked-by: Richard Henderson <rth@twiddle.net>


r~
