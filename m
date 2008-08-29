Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbYH2Xei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbYH2Xei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 19:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYH2Xe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 19:34:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:32143 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbYH2Xe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 19:34:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SBukGPt56cTerNwOOGjZeM0rt3+PD4NhIA6F/mDiwGfq5Gk0kETMuAkD7SOGJzgCTi
         jJSGpqxjh6pmbU5X5QdO9SsbbPJUjhEDAjMmYXHO5YKHh1RcfVvIT1NhUrRiQbISTAJW
         9J4Ie4r81yfax6CJbkGABXlRRtINr+Kf9R8QA=
Message-ID: <86802c440808291634h1904b7ffmeb1697b2050e364b@mail.gmail.com>
Date: Fri, 29 Aug 2008 16:34:26 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] dyn_array: using %pF instead of print_fn_descriptor_symbol
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20080829155319.dc76b1c0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220047669-15029-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080829152053.92fa6fd4.akpm@linux-foundation.org>
	 <86802c440808291532r15dd581cj3f69755985578c2b@mail.gmail.com>
	 <20080829155319.dc76b1c0.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 3:53 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>>       ptr = __alloc_bootmem_nopanic(total_size, max_align, 0);
>>       if (!ptr)
>>               panic("Can not alloc dyn_alloc\n");

like to give exact error message.

>
> Why duplicate the panic()?  Just call __alloc_bootmem().
>
>> #ifdef CONFIF_GENERIC_HARDIRQS
>
> That doesn't appear to have been very well tested?

ah!
it should break sparc, m68k, and s390...

>
> The code has a few coding-style glitches which checkpatch can detect.
>

should only have 80 char length warning...

YH
