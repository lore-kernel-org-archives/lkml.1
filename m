Return-Path: <linux-kernel-owner+w=401wt.eu-S1752432AbZD1Xi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbZD1Xi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 19:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbZD1Xis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 19:38:48 -0400
Received: from ioctl.codeblau.de ([80.190.240.67]:44184 "EHLO codeblau.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751326AbZD1Xir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 19:38:47 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Apr 2009 19:38:46 EDT
Date: Wed, 29 Apr 2009 01:32:05 +0200
From: Felix von Leitner <felix-linuxkernel@fefe.de>
To: linux-kernel@vger.kernel.org
Subject: gspca_vc032x not working with skype in 2.6.29
Message-ID: <20090428233205.GA29345@codeblau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I used to be able to use skype with video conferencing using
gspca_vc032x on this very hardware, but now all I get is a broken double
image.  I only get part of the actual image, the lower left part I
think, and the colors are off, and you can make out two copies of my
head.  In short: this looks like skype got a different color space than
it asked for, rgb32 vs yuv or something like that.

Is anyone here using gspca_vc032x successfully with skype on 2.6.29?

I don't remember which version worked for me, but it was about a year
ago.

Any ideas how to fix this?

Oh BTW: I tried booting 2.6.30-pre3 to see if that would help.  Not only
did it not help, I got strange pauses in the audio output in mplayer;
every couple of seconds audio output would stall for half a second.

Felix
