Return-Path: <linux-kernel-owner+w=401wt.eu-S933885AbXDASpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933885AbXDASpg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933883AbXDASpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:45:36 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:50878 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933876AbXDASpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:45:32 -0400
Date: Sun, 1 Apr 2007 20:42:59 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Kyle Moffett <mrmacman_g4@mac.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 07/16] kconfig-dynamic-frequency.diff
In-Reply-To: <B118D361-9F40-456F-96B7-E61B16B98432@mac.com>
Message-ID: <Pine.LNX.4.61.0704012040220.15102@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0704012006060.12316@yvahk01.tjqt.qr>
 <B118D361-9F40-456F-96B7-E61B16B98432@mac.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 1 2007 14:39, Kyle Moffett wrote:
>> 
>> Make HZ fully configurable through menuconfig.
>> 
>> Already posted at http://lkml.org/lkml/2006/6/18/111
>
> Instead of that, what about something like this instead:  NOTE: I know my
> mailer mangles diffs and this one was hand-edited based on Jan's diff from
> within my mailer so it probably doesn't apply, but it's enough to point out the
> idea:

> config HZ
> -	int
> +	int if !HZ_CUSTOM
> +	int "Customized HZ value" if HZ_CUSTOM
> default 100 if HZ_100
> default 250 if HZ_250
> default 1000 if HZ_1000

People always come up with new complexities I never thought kconfig
would be able to do. Nice stuff. I'll take up on your idea and
incorporate it right away.

But I would have to ask: Why do we need 100/250/300/1000 if there is
anyway an input field for the user to enter - s/he should read the
help text for Known Good values, should not s/he?


Jan
-- 
