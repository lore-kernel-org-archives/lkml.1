Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbYGXMpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbYGXMpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 08:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbYGXMpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 08:45:23 -0400
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:48252 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbYGXMpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 08:45:23 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4888796B.9070003@cam.ac.uk>
Date: Thu, 24 Jul 2008 13:45:31 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.0 (X11/20070423)
MIME-Version: 1.0
To: Eric Piel <eric.piel@tremplin-utc.net>
CC: Jonathan Cameron <Jonathan.Cameron@gmail.com>, mgross@linux.intel.com,
       Dmitry Torokhov <dtor@mail.ru>, LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       David Brownell <david-b@pacbell.net>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Jean Delvare <khali@linux-fr.org>,
       spi-devel-general@lists.sourceforge.net,
       Ben Nizette <bn@niasdigital.com>
Subject: Re: [spi-devel-general] [Patch 0/4] IndustrialIO subsystem (ADCs,
 accelerometers etc)
References: <488763AD.4050400@gmail.com>	<20080723174801.GC11009@khazad-dum.debian.net> <48884F04.4070403@tremplin-utc.net> <48887201.8090300@cam.ac.uk> <48887783.5000002@tremplin-utc.net>
In-Reply-To: <48887783.5000002@tremplin-utc.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hat done for the next
>> version (maybe driver specific for now).
> Yes, on a second though, this is a low priority point. If userspace is
> able to know if the hardware has or not freefall detection, it should be
> possible to just implement the software detection in the userspace
> daemon. People might come up with lots of "clever" algorithms for that,
> so it might be better to not do too much in the kernel ;-)
Good point; will leave that one for now.
 
> 
>>
>> At the moment the big missing element of the subsystem is an easy way of
>> querying what is there. (proc interface similar to that for the input
>> subsystem)
> You mean /sys/class/input/, right? Indeed, something inspired by the
> input subsystem should work well.
No, I meant /proc/bus/input/devices which gives machine readable description
of all devices registered with the input subsystem and their capabilities.

Makes it easier to make userspace code reasonably generic.

--
Jonathan
