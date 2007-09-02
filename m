Return-Path: <linux-kernel-owner+w=401wt.eu-S966153AbXIBL51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966153AbXIBL51 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 07:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965205AbXIBL5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 07:57:17 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:6949 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965181AbXIBL5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 07:57:15 -0400
Message-ID: <a0738740709020457n3490ee52l49d29712f3ddbb75@mail.gmail.com>
Date: Sun, 2 Sep 2007 12:57:14 +0100
From: "Alex Smith" <lkml@alex-smith.me.uk>
To: linux-kernel@vger.kernel.org
Subject: Oops in pwc v4l driver
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I found an old Philips Askey VC010 webcam and attempted to get it
working on Linux (latest git, x86_64). It worked fine, I could view
the camera in mplayer. But, however, when I went to move the camera, I
unplugged it and forgot to close mplayer. I didn't notice, moved it,
plugged it back in and immediately Mplayer died and dropped a genaral
protection fault oops + stacktrace in the kernel log. I unplugged the
camera again, and the entire system froze, most likely a kernel panic.
I've reproduced this twice, however I haven't been able to get it to
occur when using mplayer from the command line (so that I can see what
happens when it freezes). I've uploaded the 2 dmesg logs here:

http://www.alex-smith.me.uk/files/dmesg.log
http://www.alex-smith.me.uk/files/dmesg2.log

and also my .config here:

http://www.alex-smith.me.uk/files/config-2.6.23-rc5.txt

The mplayer command I used:

mplayer -cache 128 -tv
driver=v4l:width=640:height=480:outfmt=i420:device=/dev/video1 -vc
rawi420 -vo xv tv://

Thanks,
Alex
-- 
Alex Smith - http://www.alex-smith.me.uk
