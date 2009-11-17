Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbZKQSzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbZKQSzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 13:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbZKQSzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 13:55:35 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49317 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbZKQSzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 13:55:35 -0500
Date: Tue, 17 Nov 2009 19:55:39 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] strcmp: fix overflow error
Message-ID: <20091117185539.GA23385@pengutronix.de>
References: <1258476700-21323-1-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LFD.2.01.0911170922190.9384@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.01.0911170922190.9384@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

On Tue, Nov 17, 2009 at 09:41:58AM -0800, Linus Torvalds wrote:
> On Tue, 17 Nov 2009, Uwe Kleine-König wrote:
> >
> > strcmp("\x01", "\xef") returns 18 but it should return something < 0.
> > The reason is that the variable holding the result of the subtraction is
> > too small and overflows.
> 
> No. The reason is that whoever wrote that function is a moron and doesn't 
> know the standard. And your fix is not correct _either_
OK, right.

Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

(BTW, this was already broken in 2.4.0, so I was unable to find out who
is the moron :-)

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
