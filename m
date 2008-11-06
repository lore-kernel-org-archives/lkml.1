Return-Path: <linux-kernel-owner+w=401wt.eu-S1752715AbYKFPAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbYKFPAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbYKFPAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:00:36 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:58345 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbYKFPAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:00:35 -0500
Date: Thu, 6 Nov 2008 16:00:31 +0100
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mattia Dongili <malattia@linux.it>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: usb device not showing up
Message-ID: <20081106150031.GI2395@gamma.logic.tuwien.ac.at>
References: <20081104215829.GA2880@gamma.logic.tuwien.ac.at> <Pine.LNX.4.44L0.0811051102010.2573-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0811051102010.2573-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Mi, 05 Nov 2008, Alan Stern wrote:
> Well, this is a little odd.  The trace shows the modem was detected and
> enumerated correctly.  But there's nothing corresponding to when you
> loaded the hso driver.  In fact, there's nothing after uhci-hcd 
> finished starting up and the unconnected root hubs were suspended.

Strange. I will redo the thing and see if something changes the second
time. I am quite sure I loaded hsom but of course without udev running
(init=/bin/bash) no devices were created.

> Did you look in /proc/bus/usb/devices at this point?  And what about
> the files in /sys/bus/usb/drivers/hso/?

I don't remember, will redo it.

> This suggests the problem may lie in the hso driver itself, or in a
> failure to bind the driver to the device.

Well, the point is that under these circumstances, as I explained,
*there*is*no*problem*, I can use the device without any problems.

Only when I turn of the computer and turn it on again the device simply
does not show up in the usb system.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
ADLESTROP (n.)
That part of a suitcase which is designed to get snarled up on
conveyor belts at airports. Some of the more modern adlestrop designs
have a special 'quick release' feature which enables the case to flip
open at this point and fling your underclothes into the conveyor
belt's gearing mechanism.
			--- Douglas Adams, The Meaning of Liff
