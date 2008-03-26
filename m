Return-Path: <linux-kernel-owner+w=401wt.eu-S1761339AbYCZUN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761339AbYCZUN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 16:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757615AbYCZUMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 16:12:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60912 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbYCZUM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 16:12:29 -0400
Date: Wed, 26 Mar 2008 20:09:25 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Paul Mundt <lethal@linux-sh.org>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hskinnemoen@atmel.com,
       domen.puncer@telargo.com, tony@atomide.com, paul@pwsan.com
Subject: Re: [PATCH 1/3] Clocklib: add generic framework for managing clocks.
Message-ID: <20080326200925.GB7145@flint.arm.linux.org.uk>
References: <20080326154913.GA15326@doriath.ww600.siemens.net> <20080326155203.GA15405@doriath.ww600.siemens.net> <20080326170441.795fb928@hskinnemo-gx620.norway.atmel.com> <20080326161456.GA12490@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326161456.GA12490@linux-sh.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 01:14:56AM +0900, Paul Mundt wrote:
> Conversely it also has fields that I don't need. If struct clk could have
> been done generically without growing to insane sizes, it would have been
> done so in linux/clk.h a long time ago. The main thing there is API
> consistency for drivers, leaving the details up to the architecture.
> 
> It's true that there is significant overlap between the different users
> of the clock framework, but it's also not clear that there's any clean
> way to share a common implementation (especially since struct clk means
> totally different things on different architectures). I suspect everyone
> in the CC list has been through this before, also.

That's the exact reason why I never implemented any kind of framework
and just left it as an API for drivers to use.  What's behind the API
is very platform specific, and as can be seen from the comments, trying
to define something common results in something that just doesn't fit
in different ways.

Trying to make it expand to fit someone elses platform makes it unsuitable
for another due to it becoming too heavy weight.

Personally, I don't have much interest in these patches - had I been
interested in having a common framework behind it when I created the
API, I'd have written some code.

However, if folk think that they can solve the complexity problem while
still allowing for simple implementations...

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
