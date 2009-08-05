Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbZHEPlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbZHEPlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 11:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755800AbZHEPlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 11:41:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53643 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755784AbZHEPlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 11:41:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>, Daniel Mack <daniel@caiaq.de>
Subject: Re: [PATCH 1/2] ds2760: switch to new dev_pm_ops
Date: Wed, 5 Aug 2009 17:41:57 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, szabolcs.gyurko@tlt.hu, mreimer@vpop.net,
       cbou@mail.ru, pm list <linux-pm@lists.linux-foundation.org>
References: <1249476387-27325-1-git-send-email-daniel@caiaq.de> <200908051657.49810.elendil@planet.nl>
In-Reply-To: <200908051657.49810.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908051741.58698.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 August 2009, Frans Pop wrote:
> Daniel Mack wrote:
> > +static struct dev_pm_ops ds2760_battery_pm_ops = {
> > +       .suspend        = ds2760_battery_suspend,
> > +       .resume         = ds2760_battery_resume,
> > +};
> 
> Just to make sure...
> 
> Have you followed the earlier discussions on dev_pm_ops conversions and 
> are you aware that if done like this the driver no longer supports 
> hibernation?
> 
> If omitting hibernation is intentional, it should probably be justified in 
> the commit log.
> 
> See http://lkml.org/lkml/2009/7/25/118 for background.
> 
> Same goes for your patch for w1_gpio of course.

Frans, thanks for your vigilance. :-)

Daniel and everyone doing dev_pm_ops conversions or any other PM-related
things, please CC your patches to linux-pm@lists.linux-foundation.org .

Best,
Rafael
