Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbZCALuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbZCALuh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 06:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbZCALu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 06:50:28 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:61882 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbZCALu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 06:50:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N3C/am2NG/gGsDVOIBBaFBPNPM20M7u8wu4dD+yGLdXIrDKi2uht/yZiYRg2tMQvX6
         yYBUVIsWHTxljb1soKHBCilCsVp6f7wsDC1kJ1KuKv4Qs3vwQU29wvZZu67DMvelTiOM
         8qonpkOXyn8ZrNElcKxyL/286TBZFrllmuMEQ=
MIME-Version: 1.0
In-Reply-To: <20090228195143.03b1f600.krzysztof.h1@poczta.fm>
References: <46e1c7760901230433i3045f273oa109ce97e790bca3@mail.gmail.com>
	 <46e1c7760902101350r5a04d076j49cc611a843e6429@mail.gmail.com>
	 <20090211142409.b88c577e.akpm@linux-foundation.org>
	 <46e1c7760902121312o1476e734xc1fc1d6e11ce4d2e@mail.gmail.com>
	 <20090213210635.d094ffc8.krzysztof.h1@poczta.fm>
	 <20090222081517.567a29bd.krzysztof.h1@poczta.fm>
	 <46e1c7760902220125l61700421gc4045ca10ea4dd10@mail.gmail.com>
	 <20090222164052.dd5442c4.krzysztof.h1@poczta.fm>
	 <46e1c7760902222253p34a714bao5c06b0ad4d779337@mail.gmail.com>
	 <20090228195143.03b1f600.krzysztof.h1@poczta.fm>
Date: Sun, 1 Mar 2009 13:50:23 +0200
Message-ID: <46e1c7760903010350i42d84257lc82c492139607bb8@mail.gmail.com>
Subject: Re: [Linux-fbdev-devel] [PATCH] fb: hide cursor in graphics mode
From: Risto Suominen <risto.suominen@gmail.com>
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: adaplas@pol.net, Andrew Morton <akpm@linux-foundation.org>,
       geert@linux-m68k.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can confirm that the problem exists on x86 (Pentium III) platform,
too, with atyfb (3D RAGE IIC (Mach64 GZ, AGP) [0x475a rev 0x3a]),
kernel 2.6.26, and Xfbdev 1.5.99.902.

An interesting difference:

# setterm -cursor off > /dev/tty7

works on x86, but the opposite:

# setterm -cursor on > /dev/tty7

does not work on Mac (with my patch, so the cursor is off).

The setups, in my tests, on x86 and Mac, are not analogous. On x86,
atyfb is as a module, on Mac, it's linked in. On x86, I used fbset to
select the mode, on Mac, kernel command line has the mode selection.
But all this hardly matters...

Risto
