Return-Path: <linux-kernel-owner+w=401wt.eu-S1751732AbXB1U4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbXB1U4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 15:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbXB1U4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 15:56:33 -0500
Received: from mail.tpi.com ([198.107.51.143]:4508 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbXB1U4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 15:56:32 -0500
X-Greylist: delayed 1252 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Feb 2007 15:56:32 EST
Message-ID: <45E5E799.1000502@tpi.com>
Date: Wed, 28 Feb 2007 13:35:37 -0700
From: Tim Gardner <timg@tpi.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: nigel@nigel.suspend2.net, pavel@ucw.cz
CC: linux-kernel@vger.kernel.org, Ben Collins <ben.collins@ubuntu.com>
Subject: Resume from S2R fails after dpm_resume()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gentlemen,

I instrumented 2.6.21-rc1 base/power/resume.c device_resume() with
TRACE_RESUME(0) as the last statement in the function. Sure enough it
was the last hash value in the RTC after a hard reboot when resume failed:

[   12.028820]   hash matches drivers/base/power/resume.c:104

The machine appears to be absolutely wedged after initiating resume by
pressing the power button. The disk flashes for a half second or so,
then thats it.

It is a Dell XPS, BIOS rev A04. I'm using 'echo 1 > /sys/power/pm_trace;
echo mem > /sys/power/state' to initiate the S2R sequence.

Any suggestions on where to go from here?

rtg
-- 
Tim Gardner timg@tpi.com www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357
