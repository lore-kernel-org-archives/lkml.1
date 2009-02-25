Return-Path: <linux-kernel-owner+w=401wt.eu-S1763495AbZBYW0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763495AbZBYW0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 17:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763304AbZBYW0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 17:26:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34802 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761081AbZBYW0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 17:26:08 -0500
Date: Wed, 25 Feb 2009 23:26:04 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Bernd Schmidt <bernds_cb1@t-online.de>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] make CALLER_ADDRx overwriteable
Message-ID: <20090225222604.GA26938@pengutronix.de>
References: <1235600169-26912-1-git-send-email-u.kleine-koenig@pengutronix.de> <8bd0f97a0902251420k7bd00c4fhda34004d1993975a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0902251420k7bd00c4fhda34004d1993975a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 05:20:13PM -0500, Mike Frysinger wrote:
> On Wed, Feb 25, 2009 at 17:16, Uwe Kleine-König wrote:
> > The current definition of CALLER_ADDRx isn't suitable for all platforms.
> > E.g. for ARM __builtin_return_address(N) doesn't work for N > 0
> 
> afaik, the same applies to the Blackfin port.  we looked at
> implementing __builtin_return_address(N) and decided it wasnt worth
> the hassle.
I think the same applies for ARM:

	http://thread.gmane.org/gmane.comp.gcc.devel/103804

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
Peiner Strasse 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686              | Fax:   +49-5121-206917-5555 |
