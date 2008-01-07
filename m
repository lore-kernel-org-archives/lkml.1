Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbYAGB1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbYAGB1d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 20:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbYAGB10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 20:27:26 -0500
Received: from mga11.intel.com ([192.55.52.93]:13709 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbYAGB1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 20:27:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,251,1196668800"; 
   d="scan'208";a="276172940"
Subject: Re: [linux-pm][PATCH] base: Change power/wakeup output from "" to
	"unsupported" if wakeup feature isn't supported by a device
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080104114832.GA4114@elf.ucw.cz>
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>
	 <20080104114832.GA4114@elf.ucw.cz>
Content-Type: text/plain
Organization: Intel
Date: Mon, 07 Jan 2008 09:21:59 +0800
Message-Id: <1199668919.19185.16.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-04 at 12:48 +0100, Pavel Machek wrote:
> Hi!
> 
> > If a device can't support wakeup, its /sys/devices/.../power/wakeup output is
> > empty, this is confusing, a user doesn't know if it supports wakeup feature
> > unless he/she read the ralated source code, for this case, it is more
> > reasonable to output "unsupported". Otherwise, no matter what value the user
> > sets to /sys/devices/.../power/wakeup, the result is the same:  Invalid argument,
> > so the user doesn't know why.
> > 
> > This patch changes empty output to "unsupported" in order that a user knows
> > wakeup feature isn't supported by this device when he/she
> > 'cat /sys/devices/.../power/wakeup', please consider to apply,
> > thanks.
> 
> What about simply removing "wakuep" file if wakeup is not supported?
> 									Pavel
At the beginning, i did that as you said, but it can't work, some
power/wakeup will disappear although they can be disabled or enabled, so
it is only one feasible way to make it exist permanently.
> 

