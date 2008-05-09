Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbYEIUj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbYEIUj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 16:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbYEIUjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 16:39:18 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:12996 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbYEIUjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 16:39:17 -0400
Date: Fri, 9 May 2008 22:38:45 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
       i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
Subject: Re: [RFC][PATCH 2/4] RTC: SWARM I2C board initialization
Message-ID: <20080509223845.4a38d751@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.55.0805092054030.10552@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805070031410.16173@cliff.in.clinika.pl>
	<20080507085953.2c08b854@hyperion.delvare>
	<Pine.LNX.4.55.0805072145040.25644@cliff.in.clinika.pl>
	<20080508105905.3209c659@hyperion.delvare>
	<Pine.LNX.4.55.0805082344040.5944@cliff.in.clinika.pl>
	<20080509092835.3bbf0f55@hyperion.delvare>
	<Pine.LNX.4.55.0805092054030.10552@cliff.in.clinika.pl>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maciej,

On Fri, 9 May 2008 21:27:04 +0100 (BST), Maciej W. Rozycki wrote:
>  Well, sorry, but I could only sense the lack of style in this piece of
> code, which is why I tried to apply some.

I agree, i2c-sibyte is very old code, and unmaintained, coding style is
horrible. That's one more reason to not include random style cleanups
in a patch doing functional changes, the improvement will hardly be
visible. If you care about cleaning up the code of this driver - and I
would appreciate that - please make a separate patch.

>                                            You are free to disagree and as
> you have undertaken maintenance of this area I am going to respect it.

And I thank you for that.

-- 
Jean Delvare
