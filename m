Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbYFJJqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbYFJJqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 05:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbYFJJqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 05:46:14 -0400
Received: from 85-10-209-111.clients.your-server.de ([85.10.209.111]:38246
	"EHLO mail.road.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbYFJJqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 05:46:13 -0400
From: Uli Luckas <u.luckas@road.de>
Organization: Road GmbH
To: Ryan Mallon <ryan@bluewatersys.com>
Subject: Re: [PATCH, RFC] Earlier I2C initialization
Date: Tue, 10 Jun 2008 11:46:11 +0200
User-Agent: KMail/1.9.9
Cc: Jean Delvare <khali@linux-fr.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
References: <200806091541.43899.u.luckas@road.de> <20080610085708.12c2d2a2@hyperion.delvare> <484EF343.9090102@bluewatersys.com>
In-Reply-To: <484EF343.9090102@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806101146.11915.u.luckas@road.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OT: David Brownell, I get bounces from your mail server refering me to a site 
that is down:
http://worldnet.att.net/general-info/bls_info/block_inquiry.html

On Tuesday, 10. June 2008, Ryan Mallon wrote:
> Jean Delvare wrote:
> > On Tue, 10 Jun 2008 09:27:34 +1200, Ryan Mallon wrote:
> >> David Brownell wrote:
> >>> On Monday 09 June 2008, Ryan Mallon wrote:
> >>>> We have made i2c the first driver subsystem to come up in our 2.6.20
> >>>> kernel since we use i2c io expanders for power domain control. All we
> >>>> did was change drivers/Makefile so that obj-$(CONFIG_I2C) += i2c/ is
> >>>> at the very top of the file. We didn't have any problems with doing
> >>>> this. YMMV of course.
> >
> > Why don't you simply initialize the drivers in question with
> > subsys_initcall()? That's what i2c-pnx, i2c-omap, i2c-davinci and
> > tps65010 are doing at the moment.
>
> How does this work for embedded devices where the same architecture is
> used in many different configurations? For example, we have a PXA270
> setup where we need i2c early, but many other PXA setups do not, so
> making i2c-pxa subsys_initcall to support a single board is maybe the
> wrong way to go?
>
Why would an architecture not want i2c to be available early? The only reason 
would be dependencies of the bus driver. These are constant over all pxa 
platforms though. So most likely the platforms that don't _need_ early i2c 
just don't care.

-- 

------- ROAD ...the handyPC Company - - -  ) ) )

Uli Luckas
Software Development

ROAD GmbH
Bennigsenstr. 14 | 12159 Berlin | Germany
fon: +49 (30) 230069 - 64 | fax: +49 (30) 230069 - 69
url: www.road.de

Amtsgericht Charlottenburg: HRB 96688 B
Managing directors: Hans-Peter Constien, Hubertus von Streit
