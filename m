Return-Path: <linux-kernel-owner+w=401wt.eu-S1761873AbYD2KnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761873AbYD2KnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 06:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759415AbYD2Km5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 06:42:57 -0400
Received: from rv-out-0708.google.com ([209.85.198.251]:20007 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758163AbYD2Km4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:42:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Um/M44nmaoyQadCHprUCzoF9WgZx3FUKKaPajz5euriyOyH0LnBjTyeaAPQ3AMeNW3bV5XIOMmXCypMnXhxjQOghw+53mCboG2SOOwvSrAP2h2JIMXykQcnFgYd/l7jZfExCYJhL4gknt0VrGm+6h0BKY8LlZST+8r/9gqKEu4w=
Message-ID: <86802c440804290342i7fd0c7een527373b11762cf5c@mail.gmail.com>
Date: Tue, 29 Apr 2008 03:42:56 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
Cc: "Gabriel C" <nix.or.die@googlemail.com>,
       "Mika Fischer" <mika.fischer@zoopnet.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, balajirrao@gmail.com,
       "Andi Kleen" <andi@firstfloor.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20080429103409.GK23198@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4815DE0C.6000802@googlemail.com> <481627B7.9060406@googlemail.com>
	 <4816376B.8060907@googlemail.com> <48163F56.70704@googlemail.com>
	 <86802c440804281503q1f9e6f8anb18cd514e89b76fe@mail.gmail.com>
	 <4816562B.2070905@googlemail.com>
	 <86802c440804281623m28a5cf5x701580d0f007c097@mail.gmail.com>
	 <48167473.80207@googlemail.com>
	 <86802c440804281941h440c7a86kd86fd4d9dcf91ad4@mail.gmail.com>
	 <20080429103409.GK23198@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 3:34 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>  > v2: fix -1 for UC checking
>  > v3: default to disable, and need use enable_mtrr_cleanup to enable this feature
>  >     skip the var state change warning.
>  >     remove next_basek in range_to_mtrr()
>  > v4: correct warning mask.
>  > v5: CONFIG_MTRR_SANITIZER
>  > v6: 1g, 2g, 512 aligment with extra hole
>
>  thanks Yinghai, i picked up v6.

please use v8 instead. will send it out in minutes.
also it need
[PATCH 2/2] x86: fix trimming e820 with MTRR holes.
it could check range is not coverred below 4g when 8g ram installed.

YH
