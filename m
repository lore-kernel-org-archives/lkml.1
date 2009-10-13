Return-Path: <linux-kernel-owner+w=401wt.eu-S1761044AbZJMTCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761044AbZJMTCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 15:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761035AbZJMTCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 15:02:15 -0400
Received: from thunk.org ([69.25.196.29]:37276 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761032AbZJMTCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 15:02:14 -0400
Date: Tue, 13 Oct 2009 15:00:55 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org, Keith Packard <keithp@keithp.com>
Subject: Re: 2.6.32 regression (bisected): Video tearing/glitching with
	T400 laptops
Message-ID: <20091013190055.GI8175@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	"Carlos R. Mafra" <crmafra2@gmail.com>,
	Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org,
	Keith Packard <keithp@keithp.com>
References: <E1Mtqnb-0002x7-TJ@closure.thunk.org> <20091008103620.5e5aae66@jbarnes-g45> <20091010204106.GA8251@mit.edu> <20091012095438.1e82b54f@jbarnes-g45> <20091012184651.GA4603@Pilar.aei.mpg.de> <20091012120510.16bd1194@jbarnes-g45> <20091013023146.GA8414@mit.edu> <20091013100135.2b3d914f@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013100135.2b3d914f@jbarnes-g45>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, should I apply this on top of your previous patch, or on a
completely virgin 2.6.32-rc3 tree?


I don't know if this helps, but the amount of tearing seems to be
roughly proportional to how many "white" pixels are on the screen.
There isn't much tearing if I just have my (brown) Ubuntu 9.04 default
background image.  There is a bit more tearing on the virtual desktop
once I open an 80x52 black-on-white gnome-terminal window, so that 45%
of my widescreen has white pixels due to the backgrouin of the
gnome-terminal.

On the virtual desktop where my firefox browser is opened, the
tearing/glitching is much more frequent.  And where the
tearing/glitching is seems to be be roughly related to where the mouse
cursor happens to be.  (Usually starting at the horizontol row of
pixels where the mouse is going down towards the bottom of the screen;
although sometimes if the mouse is very close to the bottom of the
screen, there is some tearing at the top of the screen as well.)

Does this description help at all?  Would a video clip of the
tearing/glitching be useful?

						- Ted
