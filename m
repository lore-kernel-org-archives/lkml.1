Return-Path: <linux-kernel-owner+w=401wt.eu-S932602AbXBKWk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602AbXBKWk5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 17:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932604AbXBKWk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 17:40:57 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:43331 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932602AbXBKWkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 17:40:55 -0500
Subject: Re: NAK new drivers without proper power management?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <200702110144.17783.rjw@sisk.pl>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no>
	 <fa.kop49l/7yexJoUGrzk6vVeIP934@ifi.uio.no> <45CE533C.4010108@shaw.ca>
	 <200702110144.17783.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 09:40:55 +1100
Message-Id: <1171233655.4493.78.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sun, 2007-02-11 at 01:44 +0100, Rafael J. Wysocki wrote:
> > Well, it's probably more acceptable than silently doing nothing and the 
> > device failing or locking up the machine on resume, but I couldn't agree 
> > more that it's not what we want to be encouraging. Perfect may be the 
> > enemy of the good, but "works except no power management" is hardly what 
> > I would call good these days, more like pretty sloppy..
> 
> I think there are situations in which it can be justified, like:
> - The driver is not entirely finished, but we want to merge it early, because
> of many potential users,
> - The driver has only a few users who aren't interested in the suspend/resume
> functionality,

How do you determine that? How many users have to want suspend/resume
functionality before you say "Ok. It has to be done now"?

> - The device is undocumented and we don't know how to make it handle the
> suspend/resume (we may learn that in the future or not).

If we know how to initialise/cleanup, we know a good portion of what is
needed for suspend/resume. Sure, for some video chipsets, you need more
(you need to know how to reprogram the whole thing after S3), but
they're the exception. Yes, there are other cases. But on the whole,
we're not talking about esoteric knowledge.

Regards,

Nigel

