Return-Path: <linux-kernel-owner+w=401wt.eu-S1755812AbZGUTVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbZGUTVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 15:21:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755805AbZGUTVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 15:21:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42490 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736AbZGUTU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 15:20:56 -0400
Date: Tue, 21 Jul 2009 21:20:48 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] move macsonic's probe function to .devinit.text
Message-ID: <20090721192048.GA10770@pengutronix.de>
References: <1247345591-22643-12-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-13-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-14-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-15-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-16-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-17-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-18-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-19-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-20-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.OSX.2.00.0907220032230.796@silk.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.OSX.2.00.0907220032230.796@silk.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Finn,

On Wed, Jul 22, 2009 at 01:14:36AM +1000, Finn Thain wrote:
> On Sat, 11 Jul 2009, Uwe Kleine-K?nig wrote:
>
>> A pointer to mac_sonic_probe is passed to the core via  
>> platform_driver_register and so the function must not disappear when 
>> the .init sections are discarded.  Otherwise (if also having HOTPLUG=y) 
>> unbinding and binding a device to the driver via sysfs will result in 
>> an oops as does a device being registered late.
>
> This patch works for me (tested on a Quadra 630). I still get an oops on  
> rmmod, but that's a separate issue. I'll send a patch for that.
Thanks, I'll add a

	Tested-by: Finn Thain <fthain@telegraphics.com.au>

to the patch description.

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
