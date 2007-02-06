Return-Path: <linux-kernel-owner+w=401wt.eu-S965524AbXBFWj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965524AbXBFWj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965542AbXBFWj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:39:29 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:41279 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965524AbXBFWj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:39:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kW6GqcpaO87jn43q1qZ7P3lhOEQvvrnhKBm8ne2HwBu0SZZtPz+5gPTo4xDVJSiTt7D+kJ5OdBvbzg8JoMLdVYYC3ti68kZrY451xgL0RS+b/HXDxRtD6pbcQ1UDPDyxvRsLUkMC7QGUHAvdEosvoHoVcGzjtJW2qND5pVH5J/g=
Message-ID: <1defaf580702061439w5eca87e6s8d152fdec5f8c627@mail.gmail.com>
Date: Tue, 6 Feb 2007 23:39:26 +0100
From: "Haavard Skinnemoen" <hskinnemoen@gmail.com>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Cc: "David Woodhouse" <dwmw2@infradead.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070206054612.GL16722@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
	 <20070205084523.GA21858@elte.hu>
	 <1170682488.29759.795.camel@pmac.infradead.org>
	 <20070205155627.GA8354@elte.hu>
	 <1170692539.29759.856.camel@pmac.infradead.org>
	 <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu>
	 <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>
	 <1170710272.29759.894.camel@pmac.infradead.org>
	 <20070206054612.GL16722@waste.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/6/07, Matt Mackall <mpm@selenic.com> wrote:
> A number of current users are indeed bogus. Stuff like:
>
> config SUPERH
>         bool
>         default y
>         select EMBEDDED
>
> Just because you're using a SuperH board doesn't mean you want to turn
> off standard features.

I disagree. I did the exact same thing on AVR32 because !EMBEDDED
forces on tons of crap that just isn't useful on many embedded
platforms. I trust our users to actually enable for example virtual
terminal support if they happen to need it. Far from everyone do, and
it's going to end up as dead code unless they also enable the right
framebuffer driver.

Haavard
