Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab0CEHGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 02:06:32 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:34379 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab0CEHGa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 02:06:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ifS9DlHbaGMODqORMmQOdfBlmZvvwLYEEnhrMaQ80dGOlEXQoXfOpTuRLB7CCHCPso
         EhZrWfSGTcBD2ZpbWw+hy0WW05qUGEUlz7MYGDS3+gf5ON4FGeRWiOmzFif5p0bzwjR8
         zPggWyt7Ttu03LaoqhRCoqQnzg5hAsIpFooIo=
MIME-Version: 1.0
In-Reply-To: <20100305064955.GA6453@elte.hu>
References: <20100304103655.0b14343f@jbarnes-piketon>
	 <alpine.LFD.2.00.1003041047400.3751@localhost.localdomain>
	 <20100304105624.70fe845e@jbarnes-piketon>
	 <alpine.LFD.2.00.1003041101390.3751@localhost.localdomain>
	 <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com>
	 <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain>
	 <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com>
	 <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain>
	 <1267748927.3496.6.camel@nisroch> <20100305064955.GA6453@elte.hu>
Date: Fri, 5 Mar 2010 09:06:28 +0200
X-Google-Sender-Auth: ad748625d78e6cde
Message-ID: <84144f021003042306w2e017efbva2be364c1c4980a7@mail.gmail.com>
Subject: Re: [git pull] drm request 3
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ben Skeggs <skeggsb@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 5, 2010 at 8:49 AM, Ingo Molnar <mingo@elte.hu> wrote:
> The conclusion is crystal clear, breaking an ABI via a "flag day"
> cleanup/feature/etc is:
>
>  - wrong
>
>  - harmful
>
>  - limits the developer base
>
>  - limits the tester base
>
>  - wastes time and effort. (fewer developers/testers means that while _this_
>   feature was easier to add, all your _future_ features will be a bit harder
>   to do. It compounds up.)
>
>  - so it hurts even the very developer who is most convinced that this was the
>   right thing to do
>
> It's a bad technical decision throughout. It's masochistic and often suicidal
> to just about any project in essence. I've seen projects that did it once and
> died just due to that single act of stupidity. I've seen projects that have
> done it a few times and took the usage hit, limped along with the wounds and
> never grew to the size they could have achieved. I've seen projects that did
> it once, took the hit, learned from it and never did it again.

Agreed. What bothers me in this discussion is that people keep
bringing up the fact that nouveau is mostly developed by volunteers
and thus it doesn't make sense to make sure it's backwards (or
forwards) compatible. But the way I see it, it's the complete
opposite. It's _more_ important to support ABIs for community-driven
efforts because you're relying on people who by definition don't have
time to waste. While the nouveau people might have good intentions,
I'm afraid they might be severely limiting their developer and tester
base because they're not focused on real world problems (like the ones
Linus is seeing).

                         Pekka
