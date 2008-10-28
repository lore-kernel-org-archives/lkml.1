Return-Path: <linux-kernel-owner+w=401wt.eu-S1753601AbYJ1Q4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbYJ1Q4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 12:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbYJ1Q40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 12:56:26 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:57487 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751594AbYJ1Q4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 12:56:25 -0400
Date: Tue, 28 Oct 2008 19:56:23 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Trent Piepho <tpiepho@freescale.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Richard Purdie <rpurdie@rpsys.net>,
       Sean MacLennan <smaclennan@pikatech.com>,
       Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH 1/4] of_gpio: Return GPIO flags from of_get_gpio()
Message-ID: <20081028165623.GA6686@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <Pine.LNX.4.64.0810241442240.3790@t2.domain.actdsltmp> <1224889741-4167-1-git-send-email-tpiepho@freescale.com> <20081028143933.GA18453@oksana.dev.rtsoft.ru> <fa686aa40810280753lc555683y5d32da678384438@mail.gmail.com> <20081028151659.GA26444@oksana.dev.rtsoft.ru> <fa686aa40810280842t36da3998j5f7ad22acf9f582c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <fa686aa40810280842t36da3998j5f7ad22acf9f582c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 09:42:36AM -0600, Grant Likely wrote:
> On Tue, Oct 28, 2008 at 9:16 AM, Anton Vorontsov
> <avorontsov@ru.mvista.com> wrote:
> > On Tue, Oct 28, 2008 at 08:53:11AM -0600, Grant Likely wrote:
> >> That will deal with any merge window
> >> conflicts.
> >
> > This won't deal with build breakage because of API changes, which
> > means I can't submit FHCI driver to Greg, I have to wait for the
> > API changes applied.
> 
> Then we coordinate with Greg and make sure the fixup gets put in place
> before the window opens; either by bringing the patch in Ben's tree or
> by getting Greg to pull Ben's tree into -next.  This API change should
> not block Greg picking up the FHCI driver.  This is not an
> insurmountable problem.

Sounds complicated.

Ok, but if something will go wrong with the FHCI vs. of_get_gpio()
change, I'll just attribute the blame to you. :-))

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
