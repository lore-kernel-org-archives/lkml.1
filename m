Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbYKOTOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbYKOTOZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 14:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbYKOTOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 14:14:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49920 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751734AbYKOTOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 14:14:16 -0500
Date: Sat, 15 Nov 2008 19:14:14 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Richard Purdie <rpurdie@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: Fix locking for WM8350
Message-ID: <20081115191414.GA12907@opensource.wolfsonmicro.com>
References: <1226579997-3505-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1226588269-17642-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20081115173110.GD1523@ucw.cz> <20081115175050.GB12466@opensource.wolfsonmicro.com> <20081115185119.GA19900@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081115185119.GA19900@elf.ucw.cz>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2008 at 07:51:20PM +0100, Pavel Machek wrote:
> On Sat 2008-11-15 17:50:50, Mark Brown wrote:

> > Yes, that'd be safer though I'd be surprised to see systems that could
> > trigger it.

> Yes, they are uncommon. They exist; SPARC, IIRC. Plus you need

Exceptionally uncommon with the systems the WM8350 gets used with -
it's a primary PMIC for mobile devices so anything other than
uniprocessor ARM would be surprising.

> barriers on anything SMP... Just use atomic_t.

I was intending to do so next time I spin the patch.  Andrew had some
other comments and I don't have any test systems when I'm not in the
office anyway.
