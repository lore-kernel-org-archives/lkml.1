Return-Path: <linux-kernel-owner+w=401wt.eu-S1758987AbXEXN1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987AbXEXN1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 09:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757128AbXEXN1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 09:27:25 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:23555 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721AbXEXN1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 09:27:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gzQFabBCNrJkY+7+NvL5O3FCoPuX+VxzXlgiVDA4kMJAgK4Gg0Ef33urMNX9ziwEbvgWZzD8eMWyDQOiePxBR4BGGUjBuSRaGzV8otHGgOQn0tTcW4fq/s7Hly0cAcN6RQKs0aAOHSo0mJP4RyooKQe/TkaPJu7sb6iUZ+caFwI=
Message-ID: <d9b9d95f0705240627w6fb68251i359685f5a782063a@mail.gmail.com>
Date: Thu, 24 May 2007 14:27:21 +0100
From: "Renato Golin" <rengolin@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: joydev.c and saitek cyborg evo force
Cc: linux-kernel@vger.kernel.org, "Dmitry Torokhov" <dtor@insightbb.com>
In-Reply-To: <Pine.LNX.4.64.0705211444500.22906@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com>
	 <200705210016.20794.dtor@insightbb.com>
	 <Pine.LNX.4.64.0705211444500.22906@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/05/07, Jiri Kosina <jkosina@suse.cz> wrote:
> could you please turn on the HID debugging support ("Device Drivers -> HID
> devices -> HID debugging support" in menuconfig of any reasonably recent
> kernel) and show the output that appears when the joystick is plugged in,
> and also when you generate the events that are messed up? This would
> hopefully avoid any confusion regarding what is really going on and we'll
> see what we can do with it.

Hi Jiri,

I was changing joydev.c in a tainted kernel (ubuntu 2.6.20) but with
an unchanged joy structure. I'm still trying to make the new kernel
(from kernel.org) run on my box but I'm getting a device-mapper error
several times per second and it seems is something related to mdadm
raid software it was installed. Will continue to try and get the HID
debug messages (as ubuntu's source doesn't have it)

Apart from that, I did the auto calibration for two reasons:

 1. getting the min/max information from input_dev, the device was
giving me -127/127 instead of 0/4096. The problem can be below the
joydev.c level, on HID (as you say) but there's a second reason.

 2. The windows driver, developed by saitek itself (I suppose) have
exactly the same behaviour. Every time I plug the joy in it's
uncalibrated, than I have to move around a few times and play. Not
much harassment, but I believe that, if they did it in their own
driver it's because they don't trust their own hardware.

Anyway, I'll continue with the kernel 2.6.21 in which I have enabled
HID debugging messages and will send you the logs as soon as I have
them.

cheers,
--renato

Reclaim your digital rights, eliminate DRM, learn more at
http://www.defectivebydesign.org/what_is_drm
