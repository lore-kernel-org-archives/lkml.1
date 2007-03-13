Return-Path: <linux-kernel-owner+w=401wt.eu-S1030206AbXCMJWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030206AbXCMJWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 05:22:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965622AbXCMJWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 05:22:14 -0400
Received: from mail03.syd.optusnet.com.au ([211.29.132.184]:52795 "EHLO
	mail03.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965607AbXCMJWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 05:22:13 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Date: Tue, 13 Mar 2007 20:21:50 +1100
User-Agent: KMail/1.9.5
Cc: Mike Galbraith <efault@gmx.de>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200703111457.17624.kernel@kolivas.org> <1173762639.7944.45.camel@Homer.simpson.net> <20070313081805.GA22327@elte.hu>
In-Reply-To: <20070313081805.GA22327@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703132021.50712.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 March 2007 19:18, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> > [...] The situation as we speak is that you can run cpu intensive
> > tasks while watching eye-candy.  With RSDL, you can't, you feel the
> > non-interactive load instantly. [...]
>
> i have to agree with Mike that this is a material regression that cannot
> be talked around.
>
> Con, we want RSDL to /improve/ interactivity. Having new scheduler
> interactivity logic that behaves /worse/ in the presence of CPU hogs,
> which CPU hogs are even reniced to +5, than the current interactivity
> code, is i think a non-starter. Could you try to fix this, please? Good
> interactivity in the presence of CPU hogs (be them default nice level or
> nice +5) is _the_ most important scheduler interactivity metric.
> Anything else is really secondary.

Well I guess you must have missed where I asked him if he would be happy if I 
changed +5 metrics to do whatever he wanted and he refused to answer me. That 
would easily fit within that scheme. Any percentage of nice value he chose. I 
suggest 50% of nice 0. Heck I can even increase it if he likes. All I asked 
for was an answer as to whether that would satisfy his criterion.

> 	Ingo
>
> ps. please be nice to each other - both of you are long-time
>     scheduler contributors who did lots of cool stuff :-)

I have been civil. Only one email crossed the line on my part and I apologise.

-- 
-ck
