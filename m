Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbYGVNya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbYGVNya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 09:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbYGVNyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 09:54:22 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:7583 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbYGVNyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 09:54:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e8kccorgUdpJznHueSS6CuZ8AZhAOYTz0FOEsYIWSsS8koiNZtDSowTn12EMYhF1HR
         Vd6hkDcGomtOLFwENTmCVs6PSNTLODlHKt9etDgA28UbRXe1Usvgk6cypr0NaSkBqd7B
         FcwkLErptPhpthwCZebarIvOcGogMYS3ZQPh4=
Date: Tue, 22 Jul 2008 09:54:16 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, robfitz@273k.net, akpm@osdl.org,
       Vojtech Pavlik <vojtech@suse.cz>, dmonakhov@openvz.org
Subject: Re: [PATCH] hid: wellspring device quirks
Message-ID: <20080722095311.ZZRA012@mailhub.coreip.homeip.net>
References: <1215963466.12757.0.camel@alnilam> <alpine.LNX.1.10.0807221504380.3037@jikos.suse.cz> <4885E13E.1010607@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4885E13E.1010607@euromail.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 03:31:42PM +0200, Henrik Rydberg wrote:
> Jiri Kosina wrote:
> > On Sun, 13 Jul 2008, Henrik Rydberg wrote:
> > 
> >> This patch adds the HID_QUIRK_IGNORE_MOUSE quirk for the Apple USB
> >> multitouch devices based on BCM5974, aka Wellspring. These devices
> >> will instead be picked up by the new bcm5974 driver.
> > 
> > Hi Henrik,
> > 
> > is the mouse not working at all with standard HID driver?
> > 
> 
> Yes, it is working out-of-the-box, only poorly.
> 
> > I'd prefer to postpone merging this patch until bcm5974 hits mainline if
> > the device works in a limited way with standard HID driver, so that we
> > don't introduce regression.
> > 
> 
> Absolutely, this patch should be applied together with the bcm5974 driver,
> or not be applied. The driver patch is here:
> 
> http://userweb.kernel.org/~akpm/mmotm/broken-out/input-bcm5974-055-smoother-motion-irq-simplification.patch
> 
> > If the device doesn't work with HID driver at all though, it is probably
> > perfectly fine to merge it right away. Please let me know, I have no
> > knowledge about this particular device.
> 
> It is fine to leave it, but I would of course prefer to have the driver included together with this patch.

Jiri,

Should I take the quirks patch through my tree when I'm ready to apply
bcm5974?

-- 
Dmitry
