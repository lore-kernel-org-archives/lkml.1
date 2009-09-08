Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbZIHKLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbZIHKLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 06:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbZIHKLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 06:11:50 -0400
Received: from build.ossfans.org ([67.223.233.67]:35712 "EHLO
	build.ossfans.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbZIHKLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 06:11:49 -0400
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Sep 2009 06:11:49 EDT
Date: Tue, 8 Sep 2009 14:04:29 +0400
From: Sergey Lapin <slapin@ossfans.org>
To: linux-kernel@vger.kernel.org
Subject: fbcon and framebuffer app
Message-ID: <20090908100429.GB5235@build.ossfans.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all!

I have special framebuffer device (128x128x2bpp display via external
framebuffer interface on OMAP3), which works quite well, switching off
backlight with fbcon on, and blanking. A problem is that I need
to run graphics application on a framebuffer. But I also need blanking
on inactivity. Application works perfectly until blanking occurs,
then display is zeroed-out and application still redraws regions it
changes. This is ok while not really clean, but also, when activity
is recieved, backlight is on, but screen is not redrawn, since
application is not aware of blanking, so I have to force it to readraw
all screen.
So, how this should be fixed? I want to keep fbcon
auto-blanking functionality and tty, so removing fbcon is not an option.

Thanks beforehand,
S.

