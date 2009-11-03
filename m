Return-Path: <linux-kernel-owner+w=401wt.eu-S1754350AbZKCRzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbZKCRzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 12:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbZKCRzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 12:55:45 -0500
Received: from mail-iw0-f180.google.com ([209.85.223.180]:49138 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbZKCRzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 12:55:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Wv/aKri+omRW0qdV15kCtO8VWW500zF6SXulwCpAd4EPlQb4TaVJ+z/j4eCA7ZGgPF
         ZWlIdIbf6BjMZu03yE7u43Vv9x3eDza/ZSkW9bY9LyYFGboWtSMRz7VZEF7zhCPaTN9Y
         2dJrHW6CckSY/yUGep4TtmEINELje+869hDIw=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0911030930130.31845@localhost.localdomain>
References: <20091103053156.GA3212@core.coreip.homeip.net> 
	<20091103065238.GE3212@core.coreip.homeip.net> <1257232587.3420.55.camel@localhost.localdomain> 
	<alpine.LFD.2.01.0911030719430.31845@localhost.localdomain> 
	<1257262588.3420.79.camel@localhost.localdomain> <alpine.LFD.2.01.0911030738260.31845@localhost.localdomain> 
	<1257264485.3420.87.camel@localhost.localdomain> <20091103162955.GA4836@elte.hu> 
	<43e72e890911030924n26550ee4j619a41ec016281ea@mail.gmail.com> 
	<alpine.LFD.2.01.0911030930130.31845@localhost.localdomain>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 3 Nov 2009 09:55:28 -0800
Message-ID: <43e72e890911030955j63483919h9759fbb0b5e7acc3@mail.gmail.com>
Subject: Re: Please consider reverting 7d930bc33653d5592dc386a76a38f39c2e962344
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Marcel Holtmann <marcel@holtmann.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
       linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 3, 2009 at 9:37 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Tue, 3 Nov 2009, Luis R. Rodriguez wrote:
>>
>> How this sort of issue is dealt with is subjective and it is up to
>> maintainers to deal with.
>
> Not when they then complain when others hit the same issue several days
> later.
>
>> Having more information on the patch and better communication about
>> the issue it solved, and the issues that reverting it would have
>> caused would certainly have helped maintainers make a better call at a
>> regression caused by it but knowing Johannes he'd probably cook up a
>> followup fix ASAP and that is exactly what he did.
>
> He may have cooked it up, but he didn't send it to me, and he didn't even
> bother to post it as a response to people who complained about the same
> commit.
>
> The fact that people on the wireless mailing lists may have known about
> this just makes things _worse_, I think. It shows that we really _need_ to
> go around maintainers, when not going around them seems to result in days
> of delays and total waste of time for everybody.

Well I wouldn't quite say that. Me and Johannes know about it, I
cannot say everyone else who reads linux-wireless understood the
issue. I was trying to explain that the root cause of this whole issue
was non-obvious and even when I found a fix that worked for me it
turned out that wasn't the "proper" solution. So in reality the only
one who probably really understood this issue inside out and backwards
was Johannes.

  Luis
