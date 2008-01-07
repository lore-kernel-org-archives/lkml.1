Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbYAGBqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbYAGBqr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 20:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYAGBqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 20:46:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:5148 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbYAGBqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 20:46:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,251,1196668800"; 
   d="scan'208";a="276227896"
Subject: Re: [linux-pm][PATCH] base: Change power/wakeup output from "" to 
	"unsupported" if wakeup feature isn't supported by a device
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: David Brownell <david-b@pacbell.net>
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080104160933.B01D81FBAB5@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>
	 <20080104114832.GA4114@elf.ucw.cz>
	 <20080104160933.B01D81FBAB5@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Content-Type: text/plain
Organization: Intel
Date: Mon, 07 Jan 2008 09:37:59 +0800
Message-Id: <1199669879.19185.20.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-04 at 08:09 -0800, David Brownell wrote:
> > > This patch changes empty output to "unsupported" in order that a user knows
> > > wakeup feature isn't supported by this device when he/she
> > > 'cat /sys/devices/.../power/wakeup', please consider to apply,
> > > thanks.
> >
> > What about simply removing "wakuep" file if wakeup is not supported?
> 
> It may not *stay* unsupported, so I think changing it in either
> of those permanent ways would be confusing/misleading.
> 
> For example, USB devices have multiple states ... minimally, an
> unconfigured state, and a configured state.  Some have multiple
> configurations.  Only configured states can be wakeup-capable.
> So a given device might have three states, but support wakeup
> except in one of them...
If so, we can change "unsupported" to "unconfigurable" or "inoperable"
which can cover the states "unconfigured", "unsupported" and other
unknown states. :-).
> 
> - Dave
> 

