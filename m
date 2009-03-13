Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbZCMIbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbZCMIbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbZCMIaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:30:46 -0400
Received: from mail-bw0-f175.google.com ([209.85.218.175]:47268 "EHLO
	mail-bw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbZCMIap convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:30:45 -0400
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Mar 2009 04:30:44 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hKJ1/Bjw4XoOKqGfGfdRsIaqf06+jK27CGex2eDk09RiZj+qsDAeDehWqEsJD8ozpv
         ezCb/map45iwtp7NvqMdiWj3gu5V3l9iOsugqw5uM5GdHaNL3gsglcZDJcPEyuUtOp57
         kND6N4H2ENnJfs1AdI7k+pth3FLgBn33jwWTk=
MIME-Version: 1.0
In-Reply-To: <200903122225.04560.rob@landley.net>
References: <200903120437.03837.rob@landley.net>
	 <20090312210216.GB14205@uranus.ravnborg.org>
	 <10f740e80903121540i30fdaddr600ce21f4159530a@mail.gmail.com>
	 <200903122225.04560.rob@landley.net>
Date: Fri, 13 Mar 2009 09:25:15 +0100
X-Google-Sender-Auth: 1841e0d58c804a2c
Message-ID: <10f740e80903130125u39abf6c2h2a61f6bb18e7500e@mail.gmail.com>
Subject: Re: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Landley <rob@landley.net>
Cc: Sam Ravnborg <sam@ravnborg.org>, Greg Ungerer <gerg@snapgear.com>,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       linux-next@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 04:25, Rob Landley <rob@landley.net> wrote:
> Keep in mind I still haven't found an emulator for m68k that actually boots a
> linux kernel, so my m68k support is purely theoretical.  (I poked at mess and
> uae a bit today, but they don't do the "qemu -kernel" thing I'm using for the
> other targets, and qemu itself only seems to support coldfire and not a full-
> blown m68k.)  I'm following up on this because it's a regression.  Under
> 2.6.28 the m68k target was building a kernel and root filesystem, but I don't
> have hardware to run it and have never been able to test it, so isn't really
> very useful for me.  It's really just there so that if qemu grows the rest of
> m68k support (patches have been submitted but not merged), I'll be ready.

An atari_defconfig kernel (at least the one from Linus-yesterday) boots fine on
aranym (http://aranym.org).

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
