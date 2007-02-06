Return-Path: <linux-kernel-owner+w=401wt.eu-S1752320AbXBFWiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbXBFWiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbXBFWiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:38:20 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53870 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbXBFWiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:38:19 -0500
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702060841440.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
	 <20070205084523.GA21858@elte.hu>
	 <1170682488.29759.795.camel@pmac.infradead.org>
	 <20070205155627.GA8354@elte.hu>
	 <1170692539.29759.856.camel@pmac.infradead.org>
	 <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu>
	 <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>
	 <1170710272.29759.894.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org>
	 <1170711587.29759.909.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org>
	 <1170712393.29759.925.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702051409110.8424@woody.linux-foundation.org>
	 <20070205143110.fca62b57.randy.dunlap@oracle.com>
	 <Pine.LNX.4.64.0702051502370.8424@woody.linux-foundation.org>
	 <1170717694.29759.941.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702051525320.8424@woody.linux-foundation.org>
	 <1170755101.29759.960.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702060841440.8424@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 22:38:04 +0000
Message-Id: <1170801484.29759.1000.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 08:53 -0800, Linus Torvalds wrote:
> 
> WE WANT TO BE NICE.
>  - the firewall example was not an example of 'select', but of the "we 
>    want to be nice". But you simply DID NOT GET IT.

It's a very clever straw man, Linus, but it's still bogus. Not only do I
_agree_ about the firewall example, I've even implemented very similar
things already, of my own accord. I really do get it.

I don't claim that we shouldn't "be nice". You keep coming back to that
but it bears no relation to what I'm actually saying.

>  - the USB and SATA examples are *also* examples of "we want to be nice", 
>    and hell yeah, you need 'select' to do them. Claiming anything else is 
>    just stupid.
>
> So: are you stupid, or do you just refuse to even think about it? 

I claim that there are _better_ ways to do it than 'select'. I claim
that we can 'be nice' without actually screwing over the people who use
non-interactive config methods and need to turn stuff off. A number of
whom have spoken up already but are perhaps less quixotic than I am so
have given up on getting you to listen.

99% of the times I configure a kernel, it's in an RPM package. The
answer "you can use xconfig and press the question mark" isn't
wonderfully useful -- although having xconfig be the answer for those
who need the extra guidance that 'select' currently offers is perhaps a
more reasonable solution.

But it doesn't matter. I'll come up with a hack for the tools which make
them (optionally) treat 'select' of a user-visible option as if it was
just 'depends on'. And that should fix the problem.

-- 
dwmw2

