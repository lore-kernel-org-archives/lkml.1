Return-Path: <linux-kernel-owner+w=401wt.eu-S1423229AbXBUWmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423229AbXBUWmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423228AbXBUWmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:42:39 -0500
Received: from tim.rpsys.net ([194.106.48.114]:55108 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423227AbXBUWmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:42:38 -0500
Subject: Re: no backlight on radeon after recent kernel "upgrade"s
From: Richard Purdie <rpurdie@rpsys.net>
To: Alex Romosan <romosan@sycorax.lbl.gov>
Cc: Yaroslav Halchenko <kernel@onerussian.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       James Simmons <jsimmons@infradead.org>
In-Reply-To: <877iub9mu2.fsf@sycorax.lbl.gov>
References: <20070219044616.GC25659@washoe.onerussian.com>
	 <20070219000412.acad13de.akpm@linux-foundation.org>
	 <1171876788.6046.3.camel@localhost.localdomain>
	 <877iub9mu2.fsf@sycorax.lbl.gov>
Content-Type: text/plain
Date: Wed, 21 Feb 2007 22:41:57 +0000
Message-Id: <1172097718.5790.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 14:18 -0800, Alex Romosan wrote:
> Richard Purdie <rpurdie@rpsys.net> writes:
> i have exactly the same problem with 2.6.21-rc1 on a thinkpad t40
> with an ati radeon card. the machine boots up but the backlight never
> comes on. 2.6.20 worked okay.

Can you have a look at the differences between the defconfigs for 2.6.20
and 2.6.21-rc1?

If the backlight changes are at fault, I'm guessing James' Kconfig
changes to the video Kconfig would be the culprit since
FB_RADEON_BACKLIGHT only used to be selectable if PMAC_BACKLIGHT was
enabled. On a thinkpad, the backlight is probably under ACPI control.

If FB_RADEON_BACKLIGHT wasn't set for 2.6.20, can you try 2.6.21-rc1
with that option disabled?

An ls /sys/class/backlight under 2.6.20 will tell us which driver it was
using...

Thanks,

Richard


