Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759707Ab0COHlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 03:41:36 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:50747 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755326Ab0COHld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 03:41:33 -0400
Date: Mon, 15 Mar 2010 08:41:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Takashi Iwai <tiwai@suse.de>
Cc: perex@perex.cz, alsa-devel@alsa-project.org,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.34-rc1: regression: ^Z no longer stops sound
Message-ID: <20100315074132.GB8886@atrey.karlin.mff.cuni.cz>
References: <20100314075831.GA13457@elf.ucw.cz> <s5hhboijb83.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hhboijb83.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> At Sun, 14 Mar 2010 08:58:31 +0100,
> Pavel Machek wrote:
> > 
> > Hi!
> > 
> > In 2.6.33, hitting ^Z stopped mpg123 in a way you'd expect (both on
> > thinkpad and geode notebook).
> > 
> > On 2.6.34-rc1, hit ^Z and sound starts looping.
> 
> Is it an OSS app using the kernel OSS emulation or another backend?

OSS kernel emulation, yes. ... at least I think I'm using it.

> The possible cause is the rewrite of PCM hwptr updater.
> Jaroslav, could you take a look?

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
