Return-Path: <linux-kernel-owner+w=401wt.eu-S1754111AbZJGDdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbZJGDdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 23:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbZJGDdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 23:33:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752911AbZJGDde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 23:33:34 -0400
Date: Tue, 6 Oct 2009 20:31:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Airlie <airlied@gmail.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
In-Reply-To: <alpine.LFD.2.01.0910062015200.3432@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0910062025300.3432@localhost.localdomain>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>  <alpine.LFD.2.00.0910052140100.309@localhost.localdomain>  <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com>  <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> 
 <1254864803.6035.25.camel@pasglop>  <alpine.LFD.2.01.0910061513510.3432@localhost.localdomain> <21d7e9970910061822i429344amb47b0bceb552abc6@mail.gmail.com> <alpine.LFD.2.01.0910062015200.3432@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Oct 2009, Linus Torvalds wrote:
> 
> So I literally think that our current CONFIG_LOCALVERSION_AUTO includes 
> the best of both worlds. It has the "uniquely identifying" part, but it 
> also has a part that is human-readable and useful for that reason.

Btw, that doesn't mean that I'm married to the exact details of the syntax 
etc. I like CONFIG_LOCALVERSION_AUTO, but I can also see why Ingo would 
prefer a "+" there instead of a "-".

And the zero-padding to five digits of the number of commits may make 
things line up nicely, and I think there was even some odd technical 
reason for it too (some package manager or other that was unhappy with 
"simple" numbers like "-1" and thought that they were a build number or 
something), but it's admittedly silly too.

So I'm not trying to say that we could not change the details or perhaps 
improve on it. What I _am_ trying to say is that conceptually that whole 
CONFIG_LOCALVERSION_AUTO is absolutely the only sane way to do things. 
Whether we could expand on it or simplify it or paint it a different bike 
shed color, I don't care much about.

So I'm not married to the exact details of our current LOCALVERSION_AUTO 
thing. But I _am_ 100% convinced that it's conceptually the right thing to 
do, unlike the other suggestions I have pooh-poohed in this thread.

		Linus
