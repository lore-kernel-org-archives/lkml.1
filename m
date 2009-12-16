Return-Path: <linux-kernel-owner+w=401wt.eu-S1762156AbZLPMPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762156AbZLPMPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 07:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762134AbZLPMO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 07:14:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:51586 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761623AbZLPMO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 07:14:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=tnRbHLlCR+seuD2Xe+TQhIWTkCExmf0uiEV0SC1EhlDV5DI8lm9oe94ZLhKyttvzd8
         03X9FcpoEQLnZfDAGPEcJSAQXQZLInVUcgaKD8kbym6nxIRgT7YIltj9Uupk0S8UCgPy
         L7ScDgmwG2pWEdC0uo4epP8ikc9u2I13A0cQE=
Date: Wed, 16 Dec 2009 13:14:52 +0100
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: Josua Dietze <digidietze@draisberghof.de>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH] move eject code from zd1211rw to usb-storage
Message-ID: <20091216131452.49ad183b@strolchi.home.s3e.de>
In-Reply-To: <4B28C2F7.7040207@draisberghof.de>
References: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com>
	<4B278191.1010009@draisberghof.de>
	<200912151611.08576.oliver@neukum.org>
	<20091215180300.GF16426@one-eyed-alien.net>
	<20091216114932.4bede511@strolchi.home.s3e.de>
	<4B28C2F7.7040207@draisberghof.de>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.1; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Dec 2009 12:22:31 +0100
Josua Dietze <digidietze@draisberghof.de> wrote:

> Stefan Seyfried schrieb:
> > Preferably some code that can be built actually?
> 
> If the "eject" from SCSI tools does not work, "usb_modeswitch" can 
> send customized bulk messages to devices.

for my device, eject seems to be enough, so I'll be trying to get
this into udev.

> http://www.draisberghof.de/usb_modeswitch/

Unfortunately it cannot be built with current libusb and once you
compile it without warnings turned off (which is the default!), you
probably don't want to run it anymore ;)

Having code in kernel has one major advantage: it gets reviewed much
more thoroughly.
-- 
Stefan Seyfried

"Any ideas, John?"
"Well, surrounding them's out."
