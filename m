Return-Path: <linux-kernel-owner+w=401wt.eu-S1761786AbZEMV4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761786AbZEMV4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 17:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758604AbZEMVzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 17:55:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51223 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980AbZEMVzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 17:55:53 -0400
Message-ID: <4A0B4179.1000504@zytor.com>
Date: Wed, 13 May 2009 14:54:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Hitoshi Mitake <h.mitake@gmail.com>, Roland Dreier <rdreier@cisco.com>,
       Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, tglx@linutronix.de,
       rpjday@crashcourse.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Remove readq()/writeq() on 32-bit
References: <49EE37AF.4020507@zytor.com>	 <20090421.173123.191021055.davem@davemloft.net>	 <adak55438gp.fsf_-_@cisco.com>	 <20090428.221228.217954247.davem@davemloft.net>	 <20090429115654.GC11586@elte.hu> <49F843BC.7020902@garzik.org>	 <adahc071ie4.fsf@cisco.com> <49F8B1A1.4010208@garzik.org> <a6b9f31a0905122232s2d23b4e3h6e447c3fa5c29ee6@mail.gmail.com> <4A0B30D0.4060806@garzik.org> <4A0B3605.8090007@zytor.com> <4A0B3BF3.1050804@garzik.org>
In-Reply-To: <4A0B3BF3.1050804@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
>>>
>> I have personally dealt with at least one device who'd want to opt out
>> of a standard readq/writeq (it's not in-tree because it never shipped,
>> unfortunately.)  Doing the opt-in headers seems like a reasonable thing
>> to do to me, but perhaps I'm just being overly paranoid.
> 
> Isn't that a variant of "punish all sane hardware, because bizarre 
> unshipped hardware exists"?
> 
> IMO the best fix is to document existing readq assumptions, and 
> standardize that definition on other platforms.
> 
> The burden of special casing for bizarre hardware should not fall on 
> /sane/ drivers and hardware, who should be the ones opting _out_ of the 
> standard regime.
> 

It sort of is, but it's also a case of "explicitly documenting your
assumptions".  You have do admit that having to #include a single extra
header file is hardly a hardship.

	-hpa

