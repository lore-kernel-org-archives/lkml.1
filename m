Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432AbZJSH4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbZJSH4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 03:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbZJSH4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 03:56:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52350 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbZJSH4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 03:56:07 -0400
Date: Mon, 19 Oct 2009 09:56:04 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Julia Lawall <julia@diku.dk>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-arm-kernel@lists.infradead.org,
       linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 7/14] drivers/mmc: Move dereference after NULL test
Message-ID: <20091019075604.GB11449@pengutronix.de>
References: <Pine.LNX.4.64.0910170839430.9213@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0910170839430.9213@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 17, 2009 at 08:40:02AM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> If the NULL test on mrq is needed, then the derefernce should be after the
> NULL test.
s/derefernce/dereference/
 
> A simplified version of the semantic match that detects this problem is as
> follows (http://coccinelle.lip6.fr/):
> 
> // <smpl>
> @match exists@
> expression x, E;
> identifier fld;
> @@
> 
> * x->fld
>   ... when != \(x = E\|&x\)
> * x == NULL
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
Other than that

Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
