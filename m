Return-Path: <linux-kernel-owner+w=401wt.eu-S1764582AbYD3TML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764582AbYD3TML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 15:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761687AbYD3TL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 15:11:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56372 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760537AbYD3TL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 15:11:57 -0400
Subject: Re: [PATCH 0/1] Embedded Maintainer(s), linux-embedded@vger list
From: David Woodhouse <dwmw2@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>
In-Reply-To: <87bq3rgq40.fsf@basil.nowhere.org>
References: <1209577322.25560.402.camel@pmac.infradead.org>
	 <87bq3rgq40.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 20:11:49 +0100
Message-Id: <1209582709.25560.441.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-30 at 20:22 +0200, Andi Kleen wrote:
> David Woodhouse <dwmw2@infradead.org> writes:
> 
> > Andrew Morton has been saying recently that we need an 'embedded
> > maintainer', to take responsibility for 'embedded issues' in the core
> > kernel, as well as trying to improve our relationship with those using
> > the Linux kernel for 'embedded' devices -- who have a reputation of
> > not working with us very closely; to their detriment as well as our
> > own.
> 
> I hope your job description doesn't include adding more and more
> CONFIGs though.
> 
> I am sure there are lots of low hanging fruit where memory can be
> saved and it's a good thing someone cares about that, but please don't
> focus on the code size only. Or if you work on that don't do it 
> using CONFIG or when you really add a new one find some other 
> that is pointless and remove it first. 
> 
> There are simply already far too many of them and they make the 
> kernel harder and harder to change.

I agree. And if we do want to pay attention to pure code size, there are
other approaches -- like --gc-sections and/or building with '--combine
-fwhole-program' which I was playing with for OLPC a while back. I must
dust that off now that the GCC fixes should mostly have made it into
current distributions.

-- 
dwmw2

