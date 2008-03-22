Return-Path: <linux-kernel-owner+w=401wt.eu-S1754933AbYCVRAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbYCVRAG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 13:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbYCVQ7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 12:59:55 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:23597 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbYCVQ7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 12:59:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=q3EgjFZolXPh32hSWmGEyoa7QjFYwNLftUlScYHIeNQ2DI9Lth19o6TIw+2h3CTzQmJOtpk35GH8JTRoId0ex8xWMiz/z9WjlYUz+yfEhzLVA8OpKmmbdIGQFPVZNFmWBjZksnAp/TxJN3Ryzl8yBiI9QxHUqzjGMR4I/5lbpac=
Message-ID: <86802c440803220959r4515e2a0n6de2d8d201545a3@mail.gmail.com>
Date: Sat, 22 Mar 2008 09:59:54 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86_64: early memtest to find bad ram
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080322120400.GE13264@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803202358.33722.yhlu.kernel@gmail.com>
	 <20080321120313.GD25225@elte.hu>
	 <86802c440803211704u4fb07074w934f32d2f95bf6a7@mail.gmail.com>
	 <20080322120400.GE13264@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2008 at 5:04 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>  > >  one structural observation: please make this unified functionality,
>  > >  so that 32-bit kernels can make use of it too.
>  >
>  > that will need to use PAE to switch 2G windows ....
>
>  well, please try some non-PAE, checks-direct-mappings approach - if
>  someone wants to extend it to the highmem bits i'm sure it will be done.

OK, First need to move some early_res code from e820_64.c to e820_32.c

or we can start to merge them. anyone is working on that?

YH
