Return-Path: <linux-kernel-owner+w=401wt.eu-S1759622AbXFDWGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622AbXFDWGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbXFDWGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:06:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:22174 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbXFDWGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:06:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pTgLrcxRXraSDonmqulyMgNVbEq2WVCveV4pO3SXj8WxUkBg1P3T50H8whnYkRpNp2P567QZakO6cJoac0zc+CaCIhdTf6f/1fAUokuDgkcFAl2UeLwBL98q6OWrFslMXd2Vc3g+C86G8+t9SzezFFpcfSCo3xciTAaBjBm5st8=
Message-ID: <d9b9d95f0706041506l257819a7pbcb8b8efc2eec049@mail.gmail.com>
Date: Mon, 4 Jun 2007 23:06:34 +0100
From: "Renato Golin" <rengolin@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: joydev.c and saitek cyborg evo force
Cc: linux-kernel@vger.kernel.org,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
In-Reply-To: <Pine.LNX.4.64.0706031139570.5177@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com>
	 <Pine.LNX.4.64.0705300207160.3961@jikos.suse.cz>
	 <d9b9d95f0705300214u7eb257fg783aefd73077d33@mail.gmail.com>
	 <Pine.LNX.4.64.0705301654560.3961@jikos.suse.cz>
	 <d9b9d95f0705300818h2eaa8130mf8a7a37966d29cc5@mail.gmail.com>
	 <d9b9d95f0705301526i66e99ef3v6c35165aa1a5f5c6@mail.gmail.com>
	 <d120d5000705311253n67d4247eh194e6f4457a0b4c@mail.gmail.com>
	 <Pine.LNX.4.64.0705312220250.5177@jikos.suse.cz>
	 <d9b9d95f0706011116j59fff917x9a86aac377f88937@mail.gmail.com>
	 <Pine.LNX.4.64.0706031139570.5177@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/07, Jiri Kosina <jkosina@suse.cz> wrote:
> Please try this patch on top of 2.6.20

Hi Jiri,

Patched and run, we're almost there... I put an additional printk on
usb/input/hid-core.c and hid/hid-input.c to assure I got the right
copy, got the messages but not the fix.

What joydev reports is a range between 0 and 255, which is better than
-127 to 127 because it's unsigned but still requires further
calibration.


> I have never used ubuntu, but why should that be that difficult? Just
> download vanilla kernel from kernel.org, use your distro's .config, make
> oldconfig && make ... ?

The kernel is really simple, problem is that I use ubuntu since
version 5 and did distupgrade to 6.06, 6.10 and now 7.04. Lots of
configurations were changed, /dev structure, root points, mount, lvm
and lots of changes were made since then.

What's annoying me to get a personalized kernel now running is the lvm
new configuration that I don't master yet (nor am willing to lately)
and that's the only thing that breaks on my ubuntu with a personalized
kernel.

The filesystem changes were quite messy, on 6.10 I lost my swap space
(kernel couldn't mount it) and I didn't have time to investigate
properly. Now, with 7.04 it's back again... I'm too old to investigate
every detail... ;)

I'm sure if I get a fresh installation, kernel.org's kernel will work
like a charm...

cheers,
--renato

Reclaim your digital rights, eliminate DRM, learn more at
http://www.defectivebydesign.org/what_is_drm
