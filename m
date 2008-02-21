Return-Path: <linux-kernel-owner+w=401wt.eu-S1766011AbYBUQdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766011AbYBUQdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762194AbYBUQdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:33:35 -0500
Received: from wx-out-0506.google.com ([66.249.82.236]:36123 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760770AbYBUQdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:33:32 -0500
Message-ID: <47BDA7D4.2060608@xaerolimit.net>
Date: Thu, 21 Feb 2008 11:33:24 -0500
From: Chris Brennan <xaero@xaerolimit.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20080209)
MIME-Version: 1.0
To: gentoo-amd64@lists.gentoo.org, gentoo-user@lists.gentoo.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [gentoo-amd64]  Re: BT8x8
References: <47B66180.3000001@xaerolimit.net>	<200802161703.17634.volker.armin.hemmann@tu-clausthal.de>	<47B73FCC.60000@xaerolimit.net> <pan.2008.02.17.00.43.07@cox.net>
In-Reply-To: <pan.2008.02.17.00.43.07@cox.net>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK ... I think I've made a little more progress, but I think I am still
missing something....

I switched to the Open Source ATI Drivers. But there are issues with this :/
    1) I can't play Doom3, so if I want to, I have to switch drivers are
restart X .... but that's not the bigger issue.

tvtime loads now. I figured out what modules to load to create the
/dev/video0 device


tuner                  64360  0
cx8800                 40124  0
cx88xx                 72036  1 cx8800
ir_common              39620  1 cx88xx
tveeprom               20240  1 cx88xx
compat_ioctl32         11072  1 cx8800
btcx_risc               7432  2 cx8800,cx88xx
vivi                   21716  1
video_buf              28932  3 cx8800,cx88xx,vivi
videodev               30592  4 cx8800,cx88xx,vivi
v4l1_compat            14340  1 videodev
v4l2_common            22336  6
tuner,cx8800,cx88xx,compat_ioctl32,vivi,videodev


modprobe vivi creates the device
modprobe cx8800 (the bttv replacement from what I can tell)
then modprove tuner

ow the problem is tvtime (and xawtv) gets stuck on screen, can't kill
the process, even after restarting X, the process is still in memory :/

So I am still missing something ....

On the upside, I have YU12/YUY2 Overlays

>From xine-check
    [ good ] found xvinfo: X-Video Extension version 2.2
    [ good ] your Xv extension supports YV12 overlays (improves MPEG
performance)
    [ good ] your Xv extension supports YUY2 overlays
    [ good ] Xv ports:  RGBA RGBT RGB2 YUY2 UYVY YV12 I420

so ... it's progress ... but I don't think a step forward :/ maybe a
step sideways .....

Anywho .. I am going to reboot one last time to get rid of these stuck
apps and reload the fglrx driver so I can play doom3.

Any more idea's would be greatly appreciated.

#################################################################################
# NOTICE: The contents of this e-mail and any attachments to it may 		#
# contain privileged and confidential information from XaeroLimit 		#
# Industries or its affiliates. This information is only for the viewing 	#
# or use of the intended recipient. If you are not the intended recipient, 	#
# you are hereby notified that any disclosure, copying, distribution or use 	#
# of, or the taking of any action in reliance upon, the information 		#
# contained in this e-mail, or any of the attachments to this e-mail, 		#
# is strictly prohibited. If you have received this e-mail in error, 		#
# please immediately notify the sender by replying to this message and 		#
# delete it from your system. 							#
#################################################################################



Duncan wrote:
> Chris Brennan <xaero@xaerolimit.net> posted 47B73FCC.60000@xaerolimit.net,
> excerpted below, on  Sat, 16 Feb 2008 14:55:56 -0500:
>
>   
>> And I get a GREEN overlay. But he minute I change something else, it
>> goes back to a black display and stays there.
>>     
>
> Well, green overlay, that IS certainly progress.  You apparently have the 
> overlay part working now.  =8^)
>
> Beyond that, others with more topical experience are likely to be of more 
> help.
>
>   
