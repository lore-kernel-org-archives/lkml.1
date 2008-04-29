Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbYD2RSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbYD2RSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbYD2RSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:18:15 -0400
Received: from rv-out-0708.google.com ([209.85.198.240]:15221 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751416AbYD2RSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:18:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ObZoUd1mLp7cWnr4Kk+/Y3nxuM78p8RZqTI379aZkDCUV/WgOsnu+0DSLG5rnD19uLk4GKBy/0/gEQvviWSmvGrRfQv3g7MoHd4NVqIXo83F/livNAd6SAbBeYXANYo3uUS8iOKT2kH1lUSwoA9U4T9vkRmHnYDJNyv1/iMQ9uE=
Message-ID: <86802c440804291018v343939c7n8cef9c8bc330b2ff@mail.gmail.com>
Date: Tue, 29 Apr 2008 10:18:11 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 2/2] x86: fix trimming e820 with MTRR holes.
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Gabriel C" <nix.or.die@googlemail.com>,
       "Mika Fischer" <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080429113539.GA27617@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804272337.40130.yhlu.kernel@gmail.com>
	 <200804281505.05764.yhlu.kernel@gmail.com>
	 <200804290157.30651.yhlu.kernel@gmail.com>
	 <200804290159.49882.yhlu.kernel@gmail.com>
	 <20080429113539.GA27617@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 4:35 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:
>
>  > @@ -760,7 +762,10 @@ void __init update_memory_range(u64 star
>  >                       continue;
>  >               add_memory_region(final_start, final_end - final_start,
>  >                                        new_type);
>  > +             real_updated_size += find_end - final_start;
>
>  s/find_end/final_end
>
>  i hope it boots ;-)

thanks

that report trimmed size. so it still boot. but report wrong trimmed
size. it will upset Gabriel.

it passed compiling, ..., that's funny.

YH
