Return-Path: <linux-kernel-owner+w=401wt.eu-S1759105AbYHAULW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759105AbYHAULW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 16:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbYHAULP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 16:11:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754331AbYHAULO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 16:11:14 -0400
Date: Fri, 1 Aug 2008 13:10:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Optimize tail handling for copy_user
In-Reply-To: <m3abfyqgbg.fsf@gravicappa.englab.brq.redhat.com>
Message-ID: <alpine.LFD.1.10.0808011308470.3277@nehalem.linux-foundation.org>
References: <m3ljzmdrqh.fsf@gravicappa.englab.brq.redhat.com> <alpine.LFD.1.10.0807280846320.3486@nehalem.linux-foundation.org> <m3ljzj60mk.fsf@gravicappa.englab.brq.redhat.com> <alpine.LFD.1.10.0807301016020.3334@nehalem.linux-foundation.org>
 <m3abfyqgbg.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 31 Jul 2008, Vitaly Mayatskikh wrote:
> 
> Yes, I see. I was messed, sorry. Your BYTES_LEFT_IN_PAGE works very
> well, tested.
> 
> Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>

Ok, this latest version _looks_ ok. How well tested is it? I'm a bit 
nervous by now. Those earlier versions that got committed had all those 
wrone registers etc.

Anyway, Ack as far as I'm concerned, but..

		Linus
