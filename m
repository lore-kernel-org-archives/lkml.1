Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbYGXNjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbYGXNjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 09:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbYGXNjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 09:39:00 -0400
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:58987 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbYGXNi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 09:38:59 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <488885FB.5070500@cam.ac.uk>
Date: Thu, 24 Jul 2008 14:39:07 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.0 (X11/20070423)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Eric Piel <eric.piel@tremplin-utc.net>,
       Jonathan Cameron <Jonathan.Cameron@gmail.com>, mgross@linux.intel.com,
       LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       David Brownell <david-b@pacbell.net>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Jean Delvare <khali@linux-fr.org>,
       spi-devel-general@lists.sourceforge.net,
       Ben Nizette <bn@niasdigital.com>
Subject: Re: [spi-devel-general] [Patch 0/4] IndustrialIO subsystem (ADCs,
 accelerometers etc)
References: <488763AD.4050400@gmail.com> <20080723174801.GC11009@khazad-dum.debian.net> <48884F04.4070403@tremplin-utc.net> <48887201.8090300@cam.ac.uk> <48887783.5000002@tremplin-utc.net> <4888796B.9070003@cam.ac.uk> <20080724092445.ZZRA012@mailhub.coreip.homeip.net>
In-Reply-To: <20080724092445.ZZRA012@mailhub.coreip.homeip.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Thu, Jul 24, 2008 at 01:45:31PM +0100, Jonathan Cameron wrote:
>>>> At the moment the big missing element of the subsystem is an easy way of
>>>> querying what is there. (proc interface similar to that for the input
>>>> subsystem)
>>> You mean /sys/class/input/, right? Indeed, something inspired by the
>>> input subsystem should work well.
>> No, I meant /proc/bus/input/devices which gives machine readable description
>> of all devices registered with the input subsystem and their capabilities.
>>
> 
> /proc/bus/input is a legacy interface (pre-sysfs). Newer subsystems
> should try to stay in /sys/.
Ah, I'd assumed it was there to provide a centralized way of discovering
what was there.  I guess it's just a matter of scanning your way through
the contents of /sys/class/input (and equivalent iio) then to find out
what is present and what is supported by each device.

Messier in a sense but guess it will work.

Ah well,

Jonathan

