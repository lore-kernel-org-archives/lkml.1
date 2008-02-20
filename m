Return-Path: <linux-kernel-owner+w=401wt.eu-S1760136AbYBTWNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136AbYBTWNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYBTWNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:13:22 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:44515 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbYBTWNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:13:21 -0500
Message-ID: <47BCA5F6.5010909@xaerolimit.net>
Date: Wed, 20 Feb 2008 17:13:10 -0500
From: Chris Brennan <xaero@xaerolimit.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20080209)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: BT8x8 TV Card
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm having a kernel related issue (I think) with the BT878 card I have
in my gentoo box.

Here are pastebin results of varius infomation, I hope I give all the
necessary info. If I am missing something or you need more, please let
me know.

dmesg -> http://rafb.net/p/MVIiSg62.html
xorg.conf -> http://rafb.net/p/dXz4Ry49.html
Xorg.0.log -> http://rafb.net/p/LbPBZT56.html
config -> http://rafb.net/p/Dm5LDM88.html

xawtv gives me a window and when I right click, I can choose what
format and region and all that jazz, but I get no picture. I do get a
green overlay w/ some static when it doesn't cause my X Session to
freeze. Below is the console output of two apps I am trying to use to
access the TV Card.

tvtime produces the following error:

    xaero@Leviathan ~ $ tvtime
    Running tvtime 1.0.2.
    Reading configuration from /etc/tvtime/tvtime.xml
    Reading configuration from /home/xaero/.tvtime/tvtime.xml
    xvoutput: No XVIDEO port found which supports YUY2 images.

    *** tvtime requires hardware YUY2 overlay support from your video card
    *** driver.  If you are using an older NVIDIA card (TNT2), then
    *** this capability is only available with their binary drivers.
    *** For some ATI cards, this feature may be found in the experimental
    *** GATOS drivers: http://gatos.souceforge.net/
    *** If unsure, please check with your distribution to see if your
    *** X driver supports hardware overlay surfaces.

    xaero@Leviathan ~ $

tvtime-scanner now that made my heart jump ... cause it scanned and
stored all my basic cable channels. But I still can't get a video
signal. So I am obviously missing something.


So hopefully someone can help me

