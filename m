Return-Path: <linux-kernel-owner+w=401wt.eu-S1761591AbZEMVGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761591AbZEMVGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 17:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761211AbZEMVGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 17:06:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37912 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760864AbZEMVGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 17:06:45 -0400
Message-ID: <4A0B3605.8090007@zytor.com>
Date: Wed, 13 May 2009 14:05:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Hitoshi Mitake <h.mitake@gmail.com>, Roland Dreier <rdreier@cisco.com>,
       Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, tglx@linutronix.de,
       rpjday@crashcourse.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Remove readq()/writeq() on 32-bit
References: <49EE37AF.4020507@zytor.com>	 <20090421.173123.191021055.davem@davemloft.net>	 <adak55438gp.fsf_-_@cisco.com>	 <20090428.221228.217954247.davem@davemloft.net>	 <20090429115654.GC11586@elte.hu> <49F843BC.7020902@garzik.org>	 <adahc071ie4.fsf@cisco.com> <49F8B1A1.4010208@garzik.org> <a6b9f31a0905122232s2d23b4e3h6e447c3fa5c29ee6@mail.gmail.com> <4A0B30D0.4060806@garzik.org>
In-Reply-To: <4A0B30D0.4060806@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> 
> Roland's patch was acked, apparently, _in spite of_ the commonly 
> accepted readq() definition already being in use!
> 
> Thusfar, I see two things:
> 
> (1) years of history has shown that non-atomic readq/writeq on 32-bit 
> platforms has been sufficient, based on testing and experience.  In 
> fact, in niu's case, a common readq/writeq would have PREVENTED a bug.
> 
> (2) unspecified fears continue to linger about non-atomicity
> 
> We should not base decisions on fear, particularly when the weight of 
> evidence and experience points in the other direction.
> 

I have personally dealt with at least one device who'd want to opt out
of a standard readq/writeq (it's not in-tree because it never shipped,
unfortunately.)  Doing the opt-in headers seems like a reasonable thing
to do to me, but perhaps I'm just being overly paranoid.

	-hpa

