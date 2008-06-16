Return-Path: <linux-kernel-owner+w=401wt.eu-S1758970AbYFPHUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbYFPHUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 03:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbYFPHUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 03:20:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:63789 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbYFPHUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 03:20:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=drhKZhIZX1PzRkaTWmHaSW/68w42MfaIBBHcJxZLJ20SIG38vBQeBc05Uwi67n55N6
         Phrjg4j06A3bXxlF5J73ocOZOuZlsuQ/Vd2HOWe01klWCOJVen1ENDs7GJDJiigC53EQ
         wX9YH1z5cI1KiFiq7FTlpplUtVa80SVIgUd4o=
Message-ID: <19f34abd0806160020m79f021e6tf0787b17acd3ac63@mail.gmail.com>
Date: Mon, 16 Jun 2008 09:20:41 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [RFC][PATCH] kmemcheck: divide and conquer
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20080616071000.GA9320@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080613140057.GA25833@damson.getinternet.no>
	 <20080614063114.GA24188@elte.hu>
	 <19f34abd0806140139i70a5056ehbd8a6f5df81549e4@mail.gmail.com>
	 <20080614090023.GA13798@elte.hu>
	 <19f34abd0806140217x1ea73a8k1cae18a12128a2b1@mail.gmail.com>
	 <20080616051504.GA3492@elte.hu>
	 <19f34abd0806152355h65876c54r1ae0aa156e839db2@mail.gmail.com>
	 <20080616071000.GA9320@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 9:10 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Vegard Nossum <vegard.nossum@gmail.com> wrote:
>>
>> Right now, I am reluctant to apply your fix because it means that
>> kmemcheck tree won't build as it is. In general, what's the way to
>> resolve these things? Do you have another branch, *-fixes, where these
>> fixlets can go until either of the conflicting changesets are merged
>> upstream? If so, it seems that that would be the right place for this
>> patch. Do you agree or do you have another solution? :-)
>
> yes, i solved it the following "Git way": i did a --no-commit merge of
> the tip/x86/irq tree into the tip/kmemcheck2 branch and then
> "git-cherry-pick --no-commit"-ed the fix and thus made it a part of that
> merge commit. This way the build failure is never visible during
> bisection either.

Aha. This means that I don't need to do anything but ack your fix.
Sounds good to me, thanks!

(I guess I will still need to check out -tip to find the source of the
memset redefinition warning.)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
