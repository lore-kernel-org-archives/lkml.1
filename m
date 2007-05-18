Return-Path: <linux-kernel-owner+w=401wt.eu-S1757162AbXERG3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162AbXERG3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 02:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbXERG3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 02:29:36 -0400
Received: from smtp-105-friday.nerim.net ([62.4.16.105]:4917 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752652AbXERG3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 02:29:36 -0400
Date: Fri, 18 May 2007 08:29:47 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, i2c@lm-sensors.org,
       Antonino Ingargiola <tritemio@gmail.com>
Subject: Re: [1/2] 2.6.22-rc1: known regressions
Message-ID: <20070518082947.64e1dfd6@hyperion.delvare>
In-Reply-To: <464CF450.20502@tmr.com>
References: <46475595.4050105@googlemail.com>
	<20070514082207.5df59f6e@hyperion.delvare>
	<464CF450.20502@tmr.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 20:33:20 -0400, Bill Davidsen wrote:
> Jean Delvare wrote:
> > Hi Michal,
> > 
> > On Sun, 13 May 2007 20:14:45 +0200, Michal Piotrowski wrote:
> >> I2C
> >>
> >> Subject    : "Sensors Applet" give an error message "No chip detected"
> >> References : http://lkml.org/lkml/2007/5/13/109
> >> Submitter  : Antonino Ingargiola <tritemio@gmail.com>
> >> Status     : Unknown
> > 
> > There is currently zero proof that this has anything to do with I2C.
>
> I believe in another thread this has been traced to a change in the 
> interface and can be solved with an upgrade for the applet.

Upgrade of the library (libsensors), actually. Or
CONFIG_SYSFS_DEPRECATED=y.

-- 
Jean Delvare
