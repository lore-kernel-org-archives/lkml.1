Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbZKIUPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbZKIUPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 15:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbZKIUPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 15:15:55 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36768 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbZKIUPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 15:15:54 -0500
Date: Mon, 9 Nov 2009 21:15:46 +0100
From: Pavel Machek <pavel@ucw.cz>
To: InKi Dae <daeinki@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Kyungmin Park <kmpark@infradead.org>
Subject: Re: [patch] added brightness feature to lcd class.
Message-ID: <20091109201541.GA28710@elf.ucw.cz>
References: <90b950fc0911020050q3bc3fae8j954ec6ed73d79b5@mail.gmail.com>
 <20091105192725.GE1392@ucw.cz>
 <90b950fc0911070443s57d2ec5ehcb5c9cf9edcf8d8c@mail.gmail.com>
 <20091107164830.GA1586@ucw.cz>
 <90b950fc0911090737tde32562qc878fac38cacabae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90b950fc0911090737tde32562qc878fac38cacabae@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-11-10 00:37:59, InKi Dae wrote:
> are you saying me that user shouldn't know if it is TFT-LCD or AMOLD?
> I agree your saying.

Parse error.

> if lcd class has brightness feature then sysfs file for controlling
> brightness will be placed
> in /sys/class/lcd/*/brightness.
> it would be a problem because the path is no sysfs you expected.
> 
> how about that symbolic link file is created by lcd class for user?
> like this,
> /sys/class/lcd/*/brightness -> /sys/class/backlight/*/brightness
> 

The symlink would have to be backwards, but yes, that would be better
than nothing. (But I still don't see why we should make it
complex. Just pretend it is backlight.)
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
