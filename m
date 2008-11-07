Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbYKGO17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbYKGO17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 09:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbYKGO1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 09:27:45 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43190 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751864AbYKGO1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 09:27:35 -0500
Date: Fri, 7 Nov 2008 14:52:50 +0100
From: Pavel Machek <pavel@suse.cz>
To: Constantin Baranov <const@mimas.ru>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2.6.28-rc3] led: ALIX.2 LEDs driver
Message-ID: <20081107135250.GA1437@ucw.cz>
References: <491097D7.4030800@mimas.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491097D7.4030800@mimas.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-11-04 22:43:35, Constantin Baranov wrote:
> Driver for PC Engines ALIX.2 and ALIX.3 LEDs.
> 
> Signed-off-by: Constantin Baranov <const@mimas.ru>
> ---
> Changes from previous version:
>  - rename from LEDS_ALIX to LEDS_ALIX2, because driver may not work
>    with possible future ALIX boards
>  - scan BIOS area (000f0000:000fffff) to ensure that current system
>    is ALIX.2/3
>  - add module parameter 'force' to allow registering LEDs without
>    BIOS test (e.g. if stock BIOS was upgraded)

What kind of ninja mutant system is that? Can't you identify it using
DMI or something?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
