Return-Path: <linux-kernel-owner+w=401wt.eu-S1753643AbZLCWKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbZLCWKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:10:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbZLCWKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:10:20 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44071 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbZLCWKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:10:19 -0500
Date: Thu, 3 Dec 2009 23:10:23 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, Nelson Castillo <arhuaco@freaks-unidos.net>,
       Russell King <linux@arm.linux.org.uk>,
       Ryan Mallon <ryan@bluewatersys.com>,
       linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, Ramax Lo <ramaxlo@gmail.com>
Subject: Re: [PATCH 15/38] move s3c_adc_remove to .devexit.text
Message-ID: <20091203221023.GB13459@pengutronix.de>
References: <1259096853-18909-7-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-8-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-9-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-10-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-11-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-12-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-13-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-14-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-15-git-send-email-u.kleine-koenig@pengutronix.de> <20091203220718.GS4808@trinity.fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091203220718.GS4808@trinity.fluff.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Thu, Dec 03, 2009 at 10:07:18PM +0000, Ben Dooks wrote:
> On Tue, Nov 24, 2009 at 10:07:10PM +0100, Uwe Kleine-König wrote:
> > The function s3c_adc_remove is used only wrapped by __devexit_p so define
> > it using __devexit.
> 
> Shall I put these into my tree?
Yes, I think your's is the right one. 

Thanks
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
