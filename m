Return-Path: <linux-kernel-owner+w=401wt.eu-S1764965AbYEUVxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764965AbYEUVxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbYEUVxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:53:25 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:37010 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbYEUVxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:53:24 -0400
Date: Wed, 21 May 2008 23:54:03 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org, perex@perex.cz
Subject: Re: Moving sound/* to drivers/ ?
Message-ID: <20080521215403.GD15136@uranus.ravnborg.org>
References: <s5hzlqjz74d.wl%tiwai@suse.de> <alpine.LFD.1.10.0805211431370.3081@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805211431370.3081@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Me personally, I've been more irritated by include/asm-xyz vs arch/xyz. It 
> would be so nice if all the arch-specific changes woudl always show up 
> under arch/ (both from a statistics standpoint, and just because then a 
> diffstat really shows arch-specific stuff really obviously, and sorts all 
> the arch-specific stuff together).

Something like:
include/asm-$ARCH/ => arch/$ARCH/include/asm/*
?

I can cook up something simple so kbuild will try both so we can
move the archs that do symlinks later than the rest.

I really like to keep the 'asm' directory so we can kill the asm symlink.

	Sam
