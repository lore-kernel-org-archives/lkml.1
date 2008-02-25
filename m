Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbYBYNBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbYBYNBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 08:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbYBYNBC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 08:01:02 -0500
Received: from qb-out-0506.google.com ([72.14.204.225]:21733 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbYBYNBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 08:01:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AZKpVQiWVmM8SjAHNoUta17fqbLQqnU6s/3d8Go5cod0qQQgkijgI9Pf+S+ZVHU95/V76/4ZZruIcQRLPR4/YaLIr2xmgeWwOlJ9eHHrYMw1df8J7WhmcprLds+Sq63QmVNl6OPBJ6gidSprUvFC0JC0Ym1zVJYXzuIDb8NS8Ms=
Message-ID: <f19298770802250500n3cc122cqb21b7ed2428b6b44@mail.gmail.com>
Date: Mon, 25 Feb 2008 16:00:58 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Pekka J Enberg" <penberg@cs.helsinki.fi>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Cc: "Michael Buesch" <mb@bu3sch.de>, "Greg KH" <greg@kroah.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Alexey Zaytsev" <zaytsev.a@protei.ru>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0802251423190.21696@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47BEAF3B.3080809@protei.ru> <200802251054.57070.mb@bu3sch.de>
	 <84144f020802250411i7a4a7c51h60ed9f9878c86422@mail.gmail.com>
	 <200802251319.03819.mb@bu3sch.de>
	 <Pine.LNX.4.64.0802251423190.21696@sbz-30.cs.Helsinki.FI>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 3:25 PM, Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> On Mon, 25 Feb 2008, Michael Buesch wrote:
>  > > Neither of which seem like acceptable solutions for a 2.6.23 -> 2.6.24
>  > > _regression_. Or maybe I am just too naive to believe Linus' statement
>  > > on not letting the kernel regress...
>  >
>  > So, please sign-off the patch that we have, if you think it's right
>  > and doesn't cause more regressions.
>
>  I did look at the patch and can gladly add a:
>
>  Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
>
Thanks for reviewing. Was it the patch I sent to Larry Finger
with the subject line "[PATCH] Fix the bcm43xx driver breakage in 2.6.24/25"
or the patch I sent with the first email in this thread? The patches are
generally the same, but the one sent to Larry was split into two pieces
and the condition on which the bcm43xx config option was hidden
changed a bit.

>  But this seems backwards. It was _your_ commit that broke the setup and
>  the patch touches a driver _you're_ maintaining.
>
>  So can we just revert commit 753f492093da7a40141bfe083073400f518f4c68
>  ("[B44]: port to native ssb support") from 2.6.24 and you can add it back
>  to 2.6.25 if the problem indeed does go away?

I'm quite sure my patch won't cause any problems, but if Greg
wants to be 100% sure there won't be any regressions introduced
in -stable, reverting the said commit should be the right thing.
