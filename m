Return-Path: <linux-kernel-owner+w=401wt.eu-S1759252AbZCZQX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252AbZCZQX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 12:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbZCZQXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 12:23:21 -0400
Received: from mx1.emlix.com ([193.175.82.87]:53962 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbZCZQXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 12:23:20 -0400
From: "Oskar Schirmer" <os@emlix.com>
Date: Thu, 26 Mar 2009 17:23:15 +0100
To: Jean Delvare <khali@linux-fr.org>
Cc: Oskar Schirmer <os@emlix.com>, Ben Dooks <ben-linux@fluff.org>,
       Chris Zankel <chris@zankel.net>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] add pca9543 driver
Message-ID: <20090326162315.GA26255@emlix.com>
References: <1238078818-25977-1-git-send-email-os@emlix.com> <20090326155105.5dfbd898@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090326155105.5dfbd898@hyperion.delvare>
Organization: emlix GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"

On Thu, Mar 26, 2009 at 15:51:05 +0100, Jean Delvare wrote:
> On Thu, 26 Mar 2009 15:46:58 +0100, Oskar Schirmer wrote:
> > support pca9543 i2c bus switch chip
> > 
> > Signed-off-by: Oskar Schirmer <os@emlix.com>
> > ---
> >  drivers/i2c/chips/Kconfig   |    3 +
> >  drivers/i2c/chips/Makefile  |    1 +
> 
> Please read the header of these two files carefully again.

Ok, I see. But how to have PCA9543 supported then?
The PCA9543 is an I2C bus switch/mux, so following
the headers it might be placed in drivers/<functionality>,
where <functionality> is "i2c bus mux", thus drivers/i2c.

As this is obviously not the solution, we might try to do the
bus muxing manually from userland, as soon as the system is up.
This wont work either, as the video drivers need the i2c bus
switch programmed before the video stuff can be initialized,
thus during bootup.

Next, the drivers proposed by Rodolfo Giometti
( http://article.gmane.org/gmane.linux.drivers.i2c/2996/ )
might add the functionality needed. As far as I can see from
Documentation/feature-removal-schedule.txt, prerequisites for
it to be accepted are given with 2.6.30, is the driver by
Rodolfo still in the queue, i.e. being merged for 2.6.30 now?

  Oskar
