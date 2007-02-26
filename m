Return-Path: <linux-kernel-owner+w=401wt.eu-S965241AbXBZMjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965241AbXBZMjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 07:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965243AbXBZMjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 07:39:17 -0500
Received: from nz-out-0506.google.com ([64.233.162.227]:42676 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965242AbXBZMjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 07:39:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cfwcjZwiFdbbkR20+PBbzeZdjbC+Eh70TYAv3Jay/7yZA8LgZiclt/cfc1ilXYa64H+gUYJSR6EtFxeitbMxM8EXNbts5Bo0hx51X4M8DaMffIMWiZ9anTCBI9pyJ5mLVY8cpKFJQEA3doiw0CuQBqr0IsgSNbdRahTuIlvrWtw=
Subject: Re: 2.6.21-rc1: framebuffer/console boot failure
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Andrew Nelless <andrew@nelless.net>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <34578.86.7.220.119.1172401665.squirrel@wmbeta.mxes.net>
References: <35472.86.7.220.119.1172237750.squirrel@wmbeta.mxes.net>
	 <20070224030950.074f88d4.akpm@linux-foundation.org>
	 <33525.86.7.220.119.1172358010.squirrel@wmbeta.mxes.net>
	 <1172359843.4415.8.camel@daplas>
	 <34578.86.7.220.119.1172401665.squirrel@wmbeta.mxes.net>
Content-Type: text/plain
Date: Mon, 26 Feb 2007 20:41:37 +0800
Message-Id: <1172493697.20842.6.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-25 at 11:07 +0000, Andrew Nelless wrote:
> On Sat, February 24, 2007 11:30 pm, Antonino A. Daplas wrote:
> >
> > How about booting with just vga=normal?
> >
> >
> > Tony
> >
> 
> That seems to work too. I've rebooted about 20 times in a row
> and it hasn't done it again yet. Why would this only occur
> at higher modes?
> 
> In the 2.6.20 dmesg log it reads "Nvidia board detected.
> Ignoring ACPI timer override." whereas in 2.6.21-rc1 it doesn't.
> Could this be the culprit?
> 

I don't know, probably the ACPI code can now probably detect the
presence or absence of the HPET timer.

Can you remove CONFIG_FB_VESA support from your kernel config but boot
as if you have vesafb (ie with vga=<VESA mode number>). Your machine may
boot to completion but you will have a blank screen.  But you should be
able to have an output in netconsole and you can start X. I wanted to
know if the lockup is related to the framebuffer.

Tony


