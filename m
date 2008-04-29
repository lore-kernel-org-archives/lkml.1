Return-Path: <linux-kernel-owner+w=401wt.eu-S1760782AbYD2RY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760782AbYD2RY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758083AbYD2RUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:20:40 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:61354 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758052AbYD2RUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:20:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y9jmn7lvPhzlZFnCWalIQaFKQjMwUuJ0SbydeVcpy0x6x84a3mht4WNCHeni7bU+vkNOhBCGYw83cxqoaRKTEtJ6X9bRGsHyt31uyY2cjwEullEGs6+ic2fB2FvSLbkRWRMChfCiihFaLChRMtmxdtWC+pG56Dl/0VlPrCSKwy8=
Message-ID: <86802c440804291020k2929d795j519f16280a261912@mail.gmail.com>
Date: Tue, 29 Apr 2008 10:20:37 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 2/2] x86: fix trimming e820 with MTRR holes.
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Gabriel C" <nix.or.die@googlemail.com>,
       "Mika Fischer" <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440804291018v343939c7n8cef9c8bc330b2ff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804272337.40130.yhlu.kernel@gmail.com>
	 <200804281505.05764.yhlu.kernel@gmail.com>
	 <200804290157.30651.yhlu.kernel@gmail.com>
	 <200804290159.49882.yhlu.kernel@gmail.com>
	 <20080429113539.GA27617@elte.hu>
	 <86802c440804291018v343939c7n8cef9c8bc330b2ff@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 10:18 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
> On Tue, Apr 29, 2008 at 4:35 AM, Ingo Molnar <mingo@elte.hu> wrote:
>  >
>  >  * Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:
>  >
>  >  > @@ -760,7 +762,10 @@ void __init update_memory_range(u64 star
>  >  >                       continue;
>  >  >               add_memory_region(final_start, final_end - final_start,
>  >  >                                        new_type);
>  >  > +             real_updated_size += find_end - final_start;
>  >
>  >  s/find_end/final_end
>  >
>  >  i hope it boots ;-)
>
>  thanks
>

that is in 32bit...

will send you new one.

YH
