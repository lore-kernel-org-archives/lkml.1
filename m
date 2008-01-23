Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbYAWKYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbYAWKYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 05:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbYAWKYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 05:24:05 -0500
Received: from smtp-103-wednesday.noc.nerim.net ([62.4.17.103]:2071 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751745AbYAWKYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 05:24:03 -0500
Date: Wed, 23 Jan 2008 11:23:50 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Vitaly Bordug <vitb@kernel.crashing.org>
Cc: Jochen Friedrich <jochen@scram.de>, Scott Wood <scottwood@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       i2c@lm-sensors.org
Subject: Re: [PATCH POWERPC] i2c: adds support for i2c bus on Frescale 
 CPM1/CPM2 controllers
Message-ID: <20080123112350.629ee615@hyperion.delvare>
In-Reply-To: <20071222001112.691b80c8@kernel.crashing.org>
References: <476C15BC.3090807@scram.de>
	<20071222001112.691b80c8@kernel.crashing.org>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Dec 2007 00:11:12 +0300, Vitaly Bordug wrote:
> On Fri, 21 Dec 2007 20:36:28 +0100
> Jochen Friedrich wrote:
> 
> > Using the port of 2.4 code from Vitaly Bordug
> > <vitb@kernel.crashing.org> and the actual algorithm used by the i2c
> > driver of the DBox code on cvs.tuxboc.org from Tmbinc, Gillem
> > (htoa@gmx.net). Renamed i2c-rpx.c and i2c-algo-8xx.c to i2c-cpm.c and
> > converted the driver to an of_platform_driver.
> > 
> 
> I had an attempt a while ago to do this but haven't had enough time to get it completed, so
> I am glad to see it finally picked up. There was some sort of discussion that time, you seem to have some of those points
> addressed but  something not, please
> check: http://lkml.org/lkml/2007/5/8/45
> 
> (for instance, cpm_i2c_shutdown() and i2c_cpm_del_bus() are void because they cant' fail) 
> 
> Also, why this was directed to Scott? This is lm-sensors stuff and is
> Jean Delvare <khali@linux-fr.org> material...

This is _i2c_ stuff and doesn't have _anything_ to do with lm-sensors.
(Don't let the i2c list address fool you.)

As the i2c subsystem maintainer, I am very pleased when contributors
get their patches reviewed and tested by people with the knowledge and
access to the target architecture and hardware. So Jochen did the right
thing by sending this patch to Scott at first.

-- 
Jean Delvare
