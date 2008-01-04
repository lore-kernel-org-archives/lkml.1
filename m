Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbYADLse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbYADLse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 06:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYADLs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 06:48:27 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:45072 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbYADLs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 06:48:26 -0500
Date: Fri, 4 Jan 2008 12:48:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Yi Yang <yi.y.yang@intel.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm][PATCH] base: Change power/wakeup output from "" to
	"unsupported" if wakeup feature isn't supported by a device
Message-ID: <20080104114832.GA4114@elf.ucw.cz>
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> If a device can't support wakeup, its /sys/devices/.../power/wakeup output is
> empty, this is confusing, a user doesn't know if it supports wakeup feature
> unless he/she read the ralated source code, for this case, it is more
> reasonable to output "unsupported". Otherwise, no matter what value the user
> sets to /sys/devices/.../power/wakeup, the result is the same:  Invalid argument,
> so the user doesn't know why.
> 
> This patch changes empty output to "unsupported" in order that a user knows
> wakeup feature isn't supported by this device when he/she
> 'cat /sys/devices/.../power/wakeup', please consider to apply,
> thanks.

What about simply removing "wakuep" file if wakeup is not supported?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
