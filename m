Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbYIVQlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbYIVQlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 12:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbYIVQlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 12:41:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43652 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbYIVQlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 12:41:05 -0400
Message-ID: <48D7CA62.1020805@zytor.com>
Date: Mon, 22 Sep 2008 09:40:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Ben Dooks <ben-linux@fluff.org>, Uwe Kleine-K?nig <ukleinek@strlen.de>,
       Denis Vlasenko <vda@port.imtp.ilyichevsk.odessa.ua>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] List of maintainers (draft #3)
References: <200202071054.g17Asst06608@Port.imtp.ilyichevsk.odessa.ua>	 <20080922081239.GA28726@strlen.de>	 <20080922091256.GH1916@fluff.org.uk> <84144f020809220223jbb71877ued9d3b2569c4cd67@mail.gmail.com>
In-Reply-To: <84144f020809220223jbb71877ued9d3b2569c4cd67@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> 
> Figuring out whom to send a patch to is not something you can automate
> because it not only depends on what you're changing but *how* you're
> changing it. The classic case being that whenever you change something
> related to RCU that's non-trivial, you almost certainly want to CC
> Paul "RCU" McKenney. But there's no *file* or *directory* pattern that
> can automatically tell you this.
> 
> Furthermore, if you're hacking on a specific part of the kernel, you
> almost certainly are doing it wrong if you don't know who the relevant
> maintainers are. For simple janitorial patches, you probably should
> just work out the *top-level* maintainers (davem for networking, ingo
> et al for x86, and so on) and send the patches to them. And when these
> simple rules fail you, fall back to patch bombing Andrew.
> 

This is, of course, true; however, there are people who should *always* 
be included when touching specific files, and this *can* be automated. 
This is particularly so when sending out cross-architectural patchsets.

So no, automation isn't a substitute for intelligence, but that doesn't 
mean that it can't be an *assistance*.

We need this.  Right now too many people screw up even the part that 
*can* be automated.

	-hpa
