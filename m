Return-Path: <linux-kernel-owner+w=401wt.eu-S1758647AbZLPTvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647AbZLPTvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 14:51:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbZLPTvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 14:51:12 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:35932 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751899AbZLPTvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 14:51:10 -0500
Date: Wed, 16 Dec 2009 22:51:08 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, David Vrabel <david.vrabel@csr.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>,
       Kumar Gala <galak@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       spi-devel-general@lists.sourceforge.net,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/7] spi/mpc8xxx: don't check platform_get_irq's return
 value against zero
Message-ID: <20091216195108.GA23952@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1260979809-24811-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <1260979809-24811-3-git-send-email-u.kleine-koenig@pengutronix.de>
 <1260979809-24811-4-git-send-email-u.kleine-koenig@pengutronix.de>
 <1260979809-24811-5-git-send-email-u.kleine-koenig@pengutronix.de>
 <1260979809-24811-6-git-send-email-u.kleine-koenig@pengutronix.de>
 <20091216163229.GA26350@oksana.dev.rtsoft.ru>
 <20091216174904.GB26325@pengutronix.de>
 <20091216182034.GA7590@oksana.dev.rtsoft.ru>
 <20091216191839.GA23614@pengutronix.de>
 <20091216193745.GA20429@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20091216193745.GA20429@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 10:37:45PM +0300, Anton Vorontsov wrote:
[...]
> which is a legacy interface that I'd like to be removed anyway.

...which means I really don't care that much to nack or ack the
patch. Do whatever you feel the best, but you must realize that
what you're doing is just papering over the real problem, and
maybe even spreading the problem further.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
