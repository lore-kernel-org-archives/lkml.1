Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab0CEQZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 11:25:44 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:55840 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab0CEQZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 11:25:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=JKvBGGGCnzM8dH9Fn3pjbisJqgxHApVkZQ8TJPsAAEwDuZs6eeS15IHFF1fqqGFkSQ
         5JFNqe6mBU11qaQvisVo8KtCAOueSRd8uwKfIO3MMGqWeoD/cY0JstyIR/jY2L1tf6Wa
         pyjjxRzgnxk76gKcK5LGhDGg4lNeFGPsKyxoI=
MIME-Version: 1.0
In-Reply-To: <20100305161311.656711e0@lxorguk.ukuu.org.uk>
References: <20100305123834.0d9c6277@lxorguk.ukuu.org.uk>
	 <20100305.063718.211238119.davem@davemloft.net>
	 <20100305151754.GB2505@tempa>
	 <20100305.072612.186421758.davem@davemloft.net>
	 <20100305154009.GC2505@tempa>
	 <ff13bc9a1003050756rca44e03uffbfa3090f96e0ac@mail.gmail.com>
	 <20100305161311.656711e0@lxorguk.ukuu.org.uk>
Date: Fri, 5 Mar 2010 17:25:40 +0100
Message-ID: <ff13bc9a1003050825k6bb09bd2kcdeb26b446f41dcb@mail.gmail.com>
Subject: Re: [git pull] drm request 3
From: Luca Barbieri <luca.barbieri@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Daniel Stone <daniel@fooishbar.org>, David Miller <davem@davemloft.net>,
       skeggsb@gmail.com, airlied@linux.ie, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, mingo@elte.hu,
       torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think you need to be clearer about that. Your distribution packaging
> may not support that out of the box. There are a variety of ways to do
> almsot all of this including having entire parallel X installs for
> development work.

Sure, but each user must manually find out how to setup that, and
create and test the setup himself (or happen to use a distribution
that somehow eases that, if any exist).

I think that Linus has a good point in saying that this should be
provided by default.
And ideally not just by the distribution, but upstream, so that people
wanting to test bleeding edge DRM drivers (not necessarily just
nouveau) can do so more easily, and beable to go back to their working
setup by rebooting should something go wrong.

> The fundamental problem you can't solve by versioning though is the exact
> one here. A new kernel that requires version X of a driver won't help if
> the newest version you have is X - 1.

Yes, but the fact that you can't have both X - 1 and X at the same
time makes it worse, since for instance bisecting won't just work.

> Yeah perhaps Fedora should have pushed an update that was smart enough to
> handle the Nouveau old/new ABI before the patch went upstream. Hindsight
> is an exact science.

Well, yes, but it can still be implemented in time for the next
distribution releases and the lesson can be learned for similar future
situations.
