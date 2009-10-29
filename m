Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbZJ2OjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbZJ2OjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 10:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbZJ2OjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 10:39:16 -0400
Received: from bu3sch.de ([62.75.166.246]:52647 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087AbZJ2OjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 10:39:15 -0400
From: Michael Buesch <mb@bu3sch.de>
To: David Miller <davem@davemloft.net>
Subject: Re: pull request: wireless-next-2.6 2009-10-28
Date: Thu, 29 Oct 2009 15:39:14 +0100
User-Agent: KMail/1.9.9
Cc: bzolnier@gmail.com, penberg@cs.helsinki.fi, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linville@tuxdriver.com
References: <200910291435.54203.bzolnier@gmail.com> <200910291514.40318.bzolnier@gmail.com> <20091029.072101.109209962.davem@davemloft.net>
In-Reply-To: <20091029.072101.109209962.davem@davemloft.net>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910291539.16476.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 October 2009 15:21:01 David Miller wrote:
> The issue is that John disagrees with you can you can't handle
> that.
> 
> So instead of continuing to discuss things with him and the
> other wireless folks, you want me to just overreach everybody
> and revert someone else's work.

In the end this results in the driver maintainer being forced to maintain
code and handle bugreports for code that he disagrees with in the first place.
This is unacceptable and has to be resolved in some way.
If it's not possible to get it reverted through John (for whatever reason),
you're in charge to help the actual code maintainer out.

> I'm not going to do that sorry, learn how to work with the
> wireless people instead.

This is not the problem.
The problem is that stuff is merged without ack from the maintainer
and it's virtually impossible to get the stuff reverted. The only real
way for the maintainer to resolve this is 1) live with it or 2) fix it.
And that's bad, because it completely invalidates his priority queue.

Just like you must not bypass John, the driver maintainers must not be bypassed, too.
The quality control does _only_ work if nobody in the chain is bypassed.
But in this situation the quality control did already fail and it should be
tried hard to resolve (=revert) the situation instead of pointing at John.

-- 
Greetings, Michael.
