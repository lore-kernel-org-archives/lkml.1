Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab0CCJeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 04:34:11 -0500
Received: from poutre.nerim.net ([62.4.16.124]:60548 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359Ab0CCJeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 04:34:07 -0500
Date: Wed, 3 Mar 2010 10:34:05 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Dima Zavin <dmitriyz@google.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, torvalds@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
Message-ID: <20100303103405.127020d8@hyperion.delvare>
In-Reply-To: <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>
References: <4B8C1867.7040201@cam.ac.uk>
	<404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Mar 2010 22:13:21 -0800, Dima Zavin wrote:
> Sorry if I'm jumping in a little late, but I'm concerned that adding
> ALS as a separate "framework" is going to set the wrong precedent. ALS
> is just one example of a class of sensors that are present on modern
> mobile devices (e.g. ALS, proximity, compass/magnetometer,
> accelerometer, etc.). Also, how does this deal with hybrid devices?

Hybrid devices are common and how they can be handled is completely
unrelated to the ALS subsystem. They are usually handled by the mfd
subsystem, and then each separate function can go to the relevant
subsystem.

> Many ALS devices have a proximity sensor on the same package. You'll
> need to deal with enabling/disabling them separately, but likely share
> a power function at the board file level (at least for arch/arm
> systems).
> 
> I definitely see the need for what you guys are trying to accomplish.
> For example, currently, we use an input device for reporting events,
> and a separate misc device node for control
> (enable/disable/configure). It's definitely suboptimal, but there
> currently isn't anything there would let us do things cleanly.
> 
> What I would love to see is a more generic sensors framework that
> handles different kinds of sensor devices, and different data
> acquisition schemes (sampled vs. change notifications).
> 
> I would love to work with you to design something more generic.

This can happen later, I see no reason to block the creation of the ALS
subsystem. Having a common framework for all ambient light sensor
drivers will already be a step forward compared to the current
situation. If improvements are needed on top of this, this can happen
later.

-- 
Jean Delvare
