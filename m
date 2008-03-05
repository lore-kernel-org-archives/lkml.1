Return-Path: <linux-kernel-owner+w=401wt.eu-S1759848AbYCEXw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848AbYCEXw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbYCEXws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:52:48 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:42340 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237AbYCEXwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:52:47 -0500
X-Greylist: delayed 1784 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Mar 2008 18:52:47 EST
Date: Thu, 6 Mar 2008 00:22:57 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25 possible regression usbfs options ignored?
Message-ID: <20080305232256.GA25019@ics.muni.cz>
References: <20080303215456.GA7747@ics.muni.cz> <20080305000326.GA4230@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080305000326.GA4230@kroah.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 06 Mar 2008 00:22:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 04:03:26PM -0800, Greg KH wrote:
> Wait, look in the directory for the devices, that is what you are
> setting the option for:
> 	$ ls -l /proc/bus/usb/001/
> 	total 0
> 	-rw-rw-r-- 1 root usb 43 Mar  4 13:29 001
> 	-rw-rw-r-- 1 root usb 59 Mar  4 13:29 004
> 	-rw-rw-r-- 1 root usb 52 Mar  4 13:29 007
> 	$ mount | grep usb
> 	usbfs on /proc/bus/usb type usbfs (rw,noexec,nosuid,devmode=0664,devgid=85)
> 
> So I think everything is just fine, right?

yes, it's my fault. My usb camera is not working anyway as gthumb now access
/dev/bus/usb/ instead of /proc/bus/usb and there are still wrong permissions in
/dev/bus/usb but it is udev issue. thanks.

-- 
Luká¹ Hejtmánek
