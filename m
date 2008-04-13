Return-Path: <linux-kernel-owner+w=401wt.eu-S1752917AbYDMSME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbYDMSME (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 14:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbYDMSLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 14:11:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42115 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbYDMSLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 14:11:54 -0400
Date: Sun, 13 Apr 2008 20:16:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Andi Kleen <andi@firstfloor.org>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: always_inline wrapper for x86's test_bit
Message-ID: <20080413181642.GA8641@one.firstfloor.org>
References: <20080413112308.GA23426@mailshack.com> <87hce5wv2h.fsf@basil.nowhere.org> <1208109831.1489.1247631595@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208109831.1489.1247631595@webmail.messagingengine.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have googled, but the only problem I found was concerning dead code 

It might come as a surprise, but google is still not omniscient.

> elimination, and in particular references to unavailable object from
> code that was expected to be discarded. The worst that can happen in 
> this case is that gcc might produce a strange construction where a
> runtime check will choose between the two alternative implementations of
> test_bit. Another is that it will select the 'wrong' implementation. 
> Both will result is some code-bloat, but at least the code should work
> properly.

Yes, but extreme code bloat can be fatal.

> I have not checked with 3.2. The oldest compiler I have available here
> is 3.3. That version compiles the functions as expected: I have found
> instances of either type in the objdump and I have not found strange
> constructions with both types there.

It would be good to check on 3.2 too to avoid potential nasty surprises.

> If you were thinking of another/bigger problem with gcc-3.2, could you 
> please give me a pointer?

Not sure what you mean here.

-Andi
