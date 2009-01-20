Return-Path: <linux-kernel-owner+w=401wt.eu-S1760996AbZATLCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760996AbZATLCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 06:02:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760675AbZATLCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 06:02:19 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:9574 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248AbZATLCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 06:02:18 -0500
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4975AF33.8040101@tremplin-utc.net>
Date: Tue, 20 Jan 2009 12:02:11 +0100
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.19) Gecko/20081231 Mandriva/2.0.0.19-1mdv2009.1 (2009.1) Thunderbird/2.0.0.19 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
Cc: Pavel Machek <pavel@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: Re: lis3: fix documentation to fit into 80 columns
References: <20090114172013.GA25948@elf.ucw.cz> <alpine.LNX.1.10.0901200027050.5377@jikos.suse.cz> <20090120101348.GI2576@elf.ucw.cz> <200901201118.05165.oliver@neukum.org>
In-Reply-To: <200901201118.05165.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum schreef:
> Am Tuesday 20 January 2009 11:13:49 schrieb Pavel Machek:
>>>>  Sysfs attributes under /sys/devices/platform/lis3lv02d/:
>>>>  position - 3D position that the accelerometer reports. Format: "(x,y,z)"
>>>> -calibrate - read: values (x, y, z) that are used as the base for input class device operation.
>>>> -            write: forces the base to be recalibrated with the current position.
> 
> So you are computing a position according acceleration readings?
Not really, the "position" is actually only the current acceleration
read from the sensor minus the calibration vector. It's more wording
problem, nothing fancy like double integration ;-)

> Isn't that common code to all accelerometers and should be put
> into a higher level?
Nevertheless, this remark is still valid, there are various code that
all the accelerometer drivers could share. I'm thinking in particular of
the sysfs interface, and joystick interface. There has been some work in
this direction with the "industrialio" subsystem. So for now I'm in
"wait and see" mode about this :-)

See you,
Eric
