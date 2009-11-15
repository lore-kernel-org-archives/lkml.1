Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbZKOSbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbZKOSbU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 13:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbZKOSbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 13:31:20 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:60644 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbZKOSbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 13:31:19 -0500
X-Greylist: delayed 1589 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Nov 2009 13:31:19 EST
Date: Sun, 15 Nov 2009 19:04:56 +0100
From: Pavel Machek <pavel@ucw.cz>
To: =?iso-8859-2?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>
Cc: Samu Onkalo <samu.p.onkalo@nokia.com>, daniel@caiaq.de,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH v2 09/10] lis3: Scale output values to mg
Message-ID: <20091115180456.GA21469@atrey.karlin.mff.cuni.cz>
References: <1257856872-11612-2-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-3-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-4-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-5-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-6-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-7-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-8-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-9-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-10-git-send-email-samu.p.onkalo@nokia.com> <4B001EF2.2090605@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B001EF2.2090605@tremplin-utc.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Op 10-11-09 13:41, Samu Onkalo schreef:
> > Report output values as 1/1000 of earth gravity.
> After the discussion started by Daniel, I'm willing to accept this patch
> "as is", just with a better log explaining why it's ok to break
> userspace ABI:
>  * the sysfs "position" attribute was never safe to be read as it could
> have different scales depending on the underlying hardware. It's now
> featuring a consistent scale, which is more or less identical to the one
> used by the 12-bits sensors
>  * the joystick interface reports the same values as before, excepted of
> course if "raw" values are requested, in which case the same remark as
> for "position" applies.

agreed.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
