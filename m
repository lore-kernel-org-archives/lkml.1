Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbYKORvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbYKORvB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 12:51:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbYKORuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 12:50:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53427 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751756AbYKORuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 12:50:51 -0500
Date: Sat, 15 Nov 2008 17:50:50 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Richard Purdie <rpurdie@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: Fix locking for WM8350
Message-ID: <20081115175050.GB12466@opensource.wolfsonmicro.com>
References: <1226579997-3505-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1226588269-17642-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20081115173110.GD1523@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081115173110.GD1523@ucw.cz>
X-Cookie: Be careful!  UGLY strikes 9 out of 10!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2008 at 06:31:10PM +0100, Pavel Machek wrote:

> Unfortunately, now you write to value w/o locking -> races
> possible. Maybe you need to make value atomic_t?

Yes, that'd be safer though I'd be surprised to see systems that could
trigger it.
