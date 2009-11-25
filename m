Return-Path: <linux-kernel-owner+w=401wt.eu-S1758172AbZKYBhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172AbZKYBhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 20:37:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758122AbZKYBhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 20:37:03 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:45430 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758117AbZKYBhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 20:37:02 -0500
Date: Wed, 25 Nov 2009 10:36:13 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Alessandro Zummo <a.zummo@towertech.it>,
       Paul Gortmaker <p_gortmaker@yahoo.com>, rtc-linux@googlegroups.com,
       Magnus Damm <damm@opensource.se>
Subject: Re: [PATCH 28/38] don't use __exit_p to wrap ds1302_rtc_remove
Message-ID: <20091125013613.GB30779@linux-sh.org>
References: <1259096853-18909-19-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-20-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-21-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-22-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-23-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-24-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-25-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-26-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-27-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-28-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259096853-18909-37-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-28-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 10:07:23PM +0100, Uwe Kleine-K??nig wrote:
> The function ds1302_rtc_remove is defined using __devexit, so don't use
> __exit_p but __devexit_p to wrap it.
> 
> Signed-off-by: Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: linux-kernel@vger.kernel.org
> Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
> Cc: rtc-linux@googlegroups.com

On Tue, Nov 24, 2009 at 10:07:32PM +0100, Uwe Kleine-K??nig wrote:
> The function sci_remove is defined without any section modifier, so
> don't use __devexit_p to wrap it.
> 
> Signed-off-by: Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Magnus Damm <damm@opensource.se>
> Cc: linux-kernel@vger.kernel.org

I've applied both of these, thanks.
