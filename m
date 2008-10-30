Return-Path: <linux-kernel-owner+w=401wt.eu-S1755613AbYJ3LPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbYJ3LPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 07:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338AbYJ3LPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 07:15:04 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:1910 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755320AbYJ3LPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 07:15:03 -0400
Date: Thu, 30 Oct 2008 14:15:00 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Trent Piepho <tpiepho@freescale.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Richard Purdie <rpurdie@rpsys.net>,
       Sean MacLennan <smaclennan@pikatech.com>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/4] of_gpio: Return GPIO flags from of_get_gpio()A
Message-ID: <20081030111500.GB22008@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <Pine.LNX.4.64.0810241442240.3790@t2.domain.actdsltmp> <1224889741-4167-1-git-send-email-tpiepho@freescale.com> <20081028143933.GA18453@oksana.dev.rtsoft.ru> <Pine.LNX.4.64.0810291857110.25957@t2.domain.actdsltmp>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810291857110.25957@t2.domain.actdsltmp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 07:21:24PM -0700, Trent Piepho wrote:
[...]
> > Can you repost a fixed version with my Ack and Cc: Andrew Morton,
> > Benjamin Herrenschmidt?
> >
> > I think this change should go into the 2.6.28, so that we can
> > write new code on top of new API. Otherwise this change will cause
> > issues in the next merge window.
> 
> If you can get your patch into Ben's -next tree before the high .28-RCs come
> out,

I can't, that's the point. Big USB patches don't go through the
powerpc tree. ;-)

> I can just rebase my patch to that tree and make the changes to any new
> callers of of_get_gpio() that are there.

Never mind, just make sure your patch goes into the powerpc-next
early, thus we could start using the new API.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
