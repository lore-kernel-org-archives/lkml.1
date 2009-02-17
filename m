Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbZBQXKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbZBQXKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 18:10:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbZBQXJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 18:09:58 -0500
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:52508 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbZBQXJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 18:09:58 -0500
Subject: Re: [PATCH] leds: triggers: introduce gpio led trigger
From: Richard Purdie <rpurdie@rpsys.net>
To: Felipe Balbi <felipe.balbi@nokia.com>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Felipe Balbi <me@felipe.balbi.com>, Felipe Balbi <me@felipebalbi.com>
In-Reply-To: <1234869491-29630-2-git-send-email-felipe.balbi@nokia.com>
References: <20090216131426.GU21181@scadufax.research.nokia.com>
	 <1234869491-29630-1-git-send-email-felipe.balbi@nokia.com>
	 <1234869491-29630-2-git-send-email-felipe.balbi@nokia.com>
Content-Type: text/plain
Date: Tue, 17 Feb 2009 23:11:13 +0000
Message-Id: <1234912273.5312.71.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-17 at 13:18 +0200, Felipe Balbi wrote:
> From: Felipe Balbi <me@felipe.balbi.com>
> 
> The gpio led trigger will allow leds to be triggered by
> gpio events.
> 
> When we give the led a gpio number, the trigger will
> request_irq() on that so we don't have to keep polling
> for gpio state.
> 
> It's useful for usecases as n810's keypad leds that could
> be triggered by the gpio event generated when user slides
> up to show the keypad.
> 
> We also provide means for userland to tell us what is the
> desired brightness for that special led when it goes on
> so userland could use information from ambient light sensors
> and not set led brightness too high if it's not necessary.
> 
> This trigger was tested with n810.

Added to the LED tree, thanks.

Richard


-- 
Richard Purdie
Intel Open Source Technology Centre

