Return-Path: <linux-kernel-owner+w=401wt.eu-S1758269AbXLUVOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269AbXLUVOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 16:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757722AbXLUVOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 16:14:10 -0500
Received: from gate.crashing.org ([63.228.1.57]:48221 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757624AbXLUVOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 16:14:08 -0500
Date: Sat, 22 Dec 2007 00:11:12 +0300
From: Vitaly Bordug <vitb@kernel.crashing.org>
To: Jochen Friedrich <jochen@scram.de>
Cc: Scott Wood <scottwood@freescale.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, i2c@lm-sensors.org, khali@linux-fr.org
Subject: Re: [PATCH POWERPC] i2c: adds support for i2c bus on Frescale
 CPM1/CPM2 controllers
Message-ID: <20071222001112.691b80c8@kernel.crashing.org>
In-Reply-To: <476C15BC.3090807@scram.de>
References: <476C15BC.3090807@scram.de>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007 20:36:28 +0100
Jochen Friedrich wrote:

> Using the port of 2.4 code from Vitaly Bordug
> <vitb@kernel.crashing.org> and the actual algorithm used by the i2c
> driver of the DBox code on cvs.tuxboc.org from Tmbinc, Gillem
> (htoa@gmx.net). Renamed i2c-rpx.c and i2c-algo-8xx.c to i2c-cpm.c and
> converted the driver to an of_platform_driver.
> 

I had an attempt a while ago to do this but haven't had enough time to get it completed, so
I am glad to see it finally picked up. There was some sort of discussion that time, you seem to have some of those points
addressed but  something not, please
check: http://lkml.org/lkml/2007/5/8/45

(for instance, cpm_i2c_shutdown() and i2c_cpm_del_bus() are void because they cant' fail) 

Also, why this was directed to Scott? This is lm-sensors stuff and is
Jean Delvare <khali@linux-fr.org> material...

-- 
Sincerely, Vitaly
