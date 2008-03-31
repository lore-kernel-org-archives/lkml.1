Return-Path: <linux-kernel-owner+w=401wt.eu-S1757858AbYCaTYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbYCaTYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 15:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbYCaTYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 15:24:41 -0400
Received: from mail9.dslextreme.com ([66.51.199.94]:51831 "HELO
	mail9.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753227AbYCaTYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 15:24:40 -0400
Message-ID: <47F13A74.8010206@gawab.com>
Date: Mon, 31 Mar 2008 12:24:36 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080228)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Regression: 2.6.25-rc5: Blank Screen: Intel 945]
References: <47D828BB.2000702@gawab.com> <200803191648.59400.jbarnes@virtuousgeek.org> <47E86C60.5040706@gawab.com> <200803251308.43830.jbarnes@virtuousgeek.org>
In-Reply-To: <200803251308.43830.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> So somehow both pipes are getting disabled, and your LCD is getting turned
> off and things never get re-enabled.  The X driver should have turned things
> back on though, after detecting what's available.  Do you have your X logs
> from the working & broken cases?  Also, did you try reproducing the blank
> screen problem w/o gdm enabled as Bryce suggested?  That could help narrow
> down if it's just an intelfb problem vs. a new intelfb/X driver interaction
> bug.

Well, I disabled gdm and tryed to trigger the blank screen. I did about ~16 reboots and it blanked out on me only 2 times.
I was using a script to reboot and/or startx. One time I'm not exactly sure if X was started, so it might have blanked out on a "startx".
The other time I'm fairly sure X wasn't started, so it blanked out on a terminal login.

Both of the blank outs were different than the ones with gdm started. Pressing ctrl+alt+f# changed nothing on the screen;
the screen seemed almost completely off (no or little backlight). A few seconds after pressing the power button the shutdown splash screen would show, but this time it was _very_ faint.

Usually, when gdm is enabled, pressing ctrl+alt+f# would "refresh" (or mode/resolution change) the screen, but it would still be blank.
Also the backlight still seamed to be on and at full brightness (although, still displaying black).

Well, I don't know what to say, it's the strangest of problems.

Justin

