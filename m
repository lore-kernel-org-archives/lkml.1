Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbZKINMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbZKINMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 08:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbZKINMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 08:12:53 -0500
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:56403 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826AbZKINMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 08:12:53 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4AF81577.1070803@cam.ac.uk>
Date: Mon, 09 Nov 2009 13:13:27 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20091029)
MIME-Version: 1.0
To: Amit Kucheria <amit.kucheria@verdurent.com>
CC: List Linux Kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/3] staging: iio: Fix typos in documentation
References: <1257772215-1396-1-git-send-email-amit.kucheria@verdurent.com>
In-Reply-To: <1257772215-1396-1-git-send-email-amit.kucheria@verdurent.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All look good to me.  Thanks,

Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> Spell-check wouln't catch these :)
> 
> Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
> Cc: Jonathan Cameron <jic23@cam.ac.uk>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/staging/iio/Documentation/device.txt   |    4 ++--
>  drivers/staging/iio/Documentation/overview.txt |    9 +++++----
>  2 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/iio/Documentation/device.txt b/drivers/staging/iio/Documentation/device.txt
> index 6916cd3..69d9570 100644
> --- a/drivers/staging/iio/Documentation/device.txt
> +++ b/drivers/staging/iio/Documentation/device.txt
> @@ -10,7 +10,7 @@ First allocate one using:
>  
>  struct iio_dev *indio_dev = iio_allocate_device();
>  
> -The fill in the following.
> +Then fill in the following:
>  
>  indio_dev->dev.parent
>    the struct device associated with the underlying hardware.
> @@ -45,5 +45,5 @@ allocated prior to registering the device with the iio-core, but must
>  be registered afterwards (otherwise the whole parentage of devices
>  gets confused)
>  
> -On remove iio_device_unregister(indio_dev) will remove the device from
> +On remove, iio_device_unregister(indio_dev) will remove the device from
>  the core, and iio_free_device will clean up.
> diff --git a/drivers/staging/iio/Documentation/overview.txt b/drivers/staging/iio/Documentation/overview.txt
> index 64584ad..e39dfc1 100644
> --- a/drivers/staging/iio/Documentation/overview.txt
> +++ b/drivers/staging/iio/Documentation/overview.txt
> @@ -24,11 +24,12 @@ hwmon with simple polled access to device channels via sysfs.
>  * Event chrdevs.  These are similar to input in that they provide a
>  route to user space for hardware triggered events. Such events include
>  threshold detectors, free-fall detectors and more complex action
> -detection.  They events themselves are currently very simple with
> +detection.  The events themselves are currently very simple with
>  merely an event code and a timestamp.  Any data associated with the
> -event must be accessed via polling. Note a given device may have one
> -or more event channel.  These events are turned on or off (if possible)
> -via sysfs interfaces.
> +event must be accessed via polling.
> +
> +Note: A given device may have one or more event channel.  These events are
> +turned on or off (if possible) via sysfs interfaces.
>  
>  * Hardware ring buffer support.  Some recent sensors have included
>  fifo / ring buffers on the sensor chip.  These greatly reduce the load

