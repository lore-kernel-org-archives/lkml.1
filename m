Return-Path: <linux-kernel-owner+w=401wt.eu-S1758688AbZLKPB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688AbZLKPB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758583AbZLKPBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:01:22 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:7684 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244AbZLKPBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:01:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=IuRA5lPyYP1waWX4vRZ8RtHkpXTw6tMy83htD7LLfj/8cA7MMf2KVSNXdmWbBbp9lX
         CXvlYBgG/LMIewK6JvNydNdzKYzbdiaKVcRZR1+Go1PFzD06pgETO7j2qtjPp4nulCgr
         tPvSOOn1aeGyW54eMTiq/KPVj9wPOsnA+9tCY=
Date: Fri, 11 Dec 2009 16:01:24 +0100
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Add support for Sphairon Homelink 1202 USB WLAN
Message-ID: <20091211160124.4db2da76@strolchi.home.s3e.de>
In-Reply-To: <20091211144221.GA6663@tuxdriver.com>
References: <1260282095-17042-1-git-send-email-stefan.seyfried@googlemail.com>
	<20091211133603.46bec686@strolchi.home.s3e.de>
	<20091211144221.GA6663@tuxdriver.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.1; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Dec 2009 09:42:22 -0500
"John W. Linville" <linville@tuxdriver.com> wrote:

> On Fri, Dec 11, 2009 at 01:36:03PM +0100, Stefan Seyfried wrote:
> > Is anyhting wrong with those?
> > Are those too trivial and "USB only" and thus better suited for direct
> > submission to Greg?
> 
> Trivial or not, they are wireless LAN patches and they go here.

That's what i guessed, too. I was just deafened by the silence ;)

> It strikes me as strange that you are hitting two drivers to support
> one device.  Are you saying that your ar9170usb has the goofy storage
> device thing using the same USB IDs that the zd1211rw devices like that
> used?  I suppose that makes some sense given the shared heritage...

Yes, exactly. And a different configuration (different endpoint),
that's why I had to touch the zd1211rw driver, even though it is
otherwise totally unrelated to the device.

The method with the reverse loop counting down from ep1 to ep0 was
chosen to be as sure as possible to not break the other devices that
are already working.

> We did just have a long (and possibly unresolved thread) about
> this type of practice (i.e. eject in the driver) not too long ago.
> But since zd1211rw is already doing this, maybe this patch is
> acceptable...?

Maybe a separate driver that is ejecting all those fake storage
devices, be it 3G modems or wireless LAN might be a good idea, but I am
probably not the right one to code that ;)
Or maybe we decide that userspace should handle it for all devices...

> Anyway, I have your patch.  Please be patient.

Thanks,

	Stefan

-- 
Stefan Seyfried

"Any ideas, John?"
"Well, surrounding them's out."
