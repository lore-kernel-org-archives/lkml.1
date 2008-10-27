Return-Path: <linux-kernel-owner+w=401wt.eu-S1752327AbYJ0RYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbYJ0RYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 13:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYJ0RYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 13:24:11 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1125 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYJ0RYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 13:24:11 -0400
Date: Mon, 27 Oct 2008 17:24:01 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] Re: [PATCH 2/2] rtc: rtc-wm8350: Add support for WM8350 RTC
Message-ID: <20081027172359.GJ5896@sirena.org.uk>
References: <1225121905-23782-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1225121905-23782-2-git-send-email-broonie@opensource.wolfsonmicro.com> <20081027180432.7deaee0a@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027180432.7deaee0a@i1501.lan.towertech.it>
X-Cookie: Did I do an INCORRECT THING??
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 06:04:32PM +0100, Alessandro Zummo wrote:

> > +	.resume = wm8350_rtc_resume,
> > +	.driver = {
> > +		.name = "wm8350-rtc",

>  I'd like rtc-wm8350 here, if it doesn't hurt anything else.

Due to needing to go through the MFD tree as well it'd make life easier
if we could leave as-is and avoid creating any merging issues (it's also
consistent with all the other WM8350 drivers).  Would that be OK?
