Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbYFENDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbYFENDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 09:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbYFENDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 09:03:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:55428 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbYFENDN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 09:03:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=P3x5+fi4LXNUoH/82MtOzzBlr5fOH4NCBJeM90D2mtXuvmc8BCtvmwl2MU+EJ36tHJ
         YyZhOi/TT3CXE3G0qkT0QVR9Yqx1ikZxVTad2kW+sMvX+WDmxZ0WAM+gdOklPWO+2MXN
         G/wUxocflq0QrSUfwZA+HbZZHE7WyMGLMOdGY=
Date: Thu, 5 Jun 2008 15:03:06 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc5
Message-ID: <20080605150306.18c00bd9@Varda>
In-Reply-To: <alpine.LFD.1.10.0806042018060.3473@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0806042018060.3473@woody.linux-foundation.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, 4 Jun 2008 20:36:24 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> escribió:

> 
> Another week, another batch of mostly pretty small fixes. Hopefully the 
> regression list is shrinking, and we've fixed at least a couple of the 
> oopses on Arjan's list.
> 
 I got this on my dmesg; is this expected/harmaless?
 (btw The wireless driver oops that i reported is gone as it is the 
 bluetooth one ;)

[    0.232963] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.233020] system 00:08: ioport range 0x4000-0x40bf could not be reserved
[    0.233075] system 00:08: ioport range 0x40c0-0x40df has been reserved
[    0.233131] system 00:08: ioport range 0x400-0x40f has been reserved
[    0.233186] system 00:08: ioport range 0x480-0x48f has been reserved
[    0.233243] system 00:08: iomem range 0xfff80000-0xffffffff could not be reserved
[    0.233694] system 00:08: iomem range 0xfec10000-0xfec10fff has been reserved
[    0.233750] system 00:08: iomem range 0xfe000000-0xfe0000ff has been reserved
[    0.233795] system 00:08: iomem range 0x0-0x0 could not be reserved
[    0.233795] system 00:08: iomem range 0x0-0x0 could not be reserved
[    0.233795] system 00:08: iomem range 0x0-0x0 could not be reserved
[    0.233795] system 00:08: iomem range 0x0-0x0 could not be reserved
[    0.233795] system 00:08: iomem range 0x0-0x0 could not be reserved
[    0.233795] system 00:08: iomem range 0x0-0x0 could not be reserved
[    0.233795] system 00:08: iomem range 0x0-0x0 could not be reserved
[    0.233795] system 00:08: iomem range 0x0-0x0 could not be reserved
[    0.233795] system 00:08: iomem range 0x0-0x0 could not be reserved
[    0.233795] system 00:08: iomem range 0x0-0x0 could not be reserved
[    0.233857] system 00:08: iomem range 0x0-0x0 could not be reserved
[    0.233912] system 00:08: iomem range 0x0-0x0 could not be reserved
[    0.233967] system 00:08: iomem range 0x0-0x0 could not be reserved
[    0.234023] system 00:08: iomem range 0x0-0x0 could not be reserved
[    0.234078] system 00:08: iomem range 0x0-0x0 could not be reserved
[    0.234695] system 00:08: iomem range 0x0-0x0 could not be reserved
[    0.234750] system 00:08: iomem range 0x0-0x0 could not be reserved
[    0.234805] system 00:08: iomem range 0x0-0x0 could not be reserved
[    0.234861] system 00:08: iomem range 0x0-0x0 could not be reserved
[    0.234916] system 00:08: iomem range 0x0-0x0 could not be reserved
[    0.234971] system 00:08: iomem range 0x0-0x0 could not be reserved
[    0.235032] system 00:0a: iomem range 0xff380000-0xffffffff could not be reserved
[    0.235096] system 00:0a: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.235152] system 00:0a: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.235208] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.235263] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.235318] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.235373] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.235434] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.235489] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.235545] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.235600] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.235655] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.235710] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.235765] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.235821] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.235876] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.235931] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.235986] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.240010] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.240066] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.240121] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.240176] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.240232] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.240287] system 00:0a: iomem range 0x0-0x0 could not be reserved
[    0.240346] system 00:0d: ioport range 0x290-0x29f has been reserved
[    0.240985] system 00:0d: iomem range 0x0-0x0 could not be reserved
[    0.241040] system 00:0d: iomem range 0x0-0x0 could not be reserved
[    0.241095] system 00:0d: iomem range 0x0-0x0 could not be reserved
[    0.241151] system 00:0d: iomem range 0x0-0x0 could not be reserved
[    0.241206] system 00:0d: iomem range 0x0-0x0 could not be reserved
[    0.241261] system 00:0d: iomem range 0x0-0x0 could not be reserved
[    0.244655] system 00:0d: iomem range 0x0-0x0 could not be reserved
[    0.244710] system 00:0d: iomem range 0x0-0x0 could not be reserved
[    0.244716] system 00:0d: iomem range 0x0-0x0 could not be reserved
[    0.244716] system 00:0d: iomem range 0x0-0x0 could not be reserved
[    0.244716] system 00:0d: iomem range 0x0-0x0 could not be reserved
[    0.244716] system 00:0d: iomem range 0x0-0x0 could not be reserved
[    0.244716] system 00:0d: iomem range 0x0-0x0 could not be reserved
[    0.244716] system 00:0d: iomem range 0x0-0x0 could not be reserved
[    0.244716] system 00:0d: iomem range 0x0-0x0 could not be reserved
[    0.244716] system 00:0d: iomem range 0x0-0x0 could not be reserved
[    0.244716] system 00:0d: iomem range 0x0-0x0 could not be reserved
[    0.244716] system 00:0d: iomem range 0x0-0x0 could not be reserved
[    0.244777] system 00:0d: iomem range 0x0-0x0 could not be reserved
[    0.244832] system 00:0d: iomem range 0x0-0x0 could not be reserved
[    0.244887] system 00:0d: iomem range 0x0-0x0 could not be reserved
[    0.244943] system 00:0d: iomem range 0x0-0x0 could not be reserved
[    0.244998] system 00:0d: iomem range 0x0-0x0 could not be reserved
[    0.245053] system 00:0d: iomem range 0x0-0x0 could not be reserved
[    0.245113] system 00:0e: iomem range 0xe0000000-0xefffffff has been reserved
[    0.245172] system 00:0e: iomem range 0x0-0x0 could not be reserved
[    0.245227] system 00:0e: iomem range 0x0-0x0 could not be reserved
[    0.245283] system 00:0e: iomem range 0x0-0x0 could not be reserved
[    0.245338] system 00:0e: iomem range 0x0-0x0 could not be reserved
[    0.245393] system 00:0e: iomem range 0x0-0x0 could not be reserved
[    0.245448] system 00:0e: iomem range 0x0-0x0 could not be reserved
[    0.245503] system 00:0e: iomem range 0x0-0x0 could not be reserved
[    0.245558] system 00:0e: iomem range 0x0-0x0 could not be reserved
[    0.245613] system 00:0e: iomem range 0x0-0x0 could not be reserved
[    0.245669] system 00:0e: iomem range 0x0-0x0 could not be reserved
[    0.245716] system 00:0e: iomem range 0x0-0x0 could not be reserved
[    0.245777] system 00:0e: iomem range 0x0-0x0 could not be reserved
[    0.245832] system 00:0e: iomem range 0x0-0x0 could not be reserved
[    0.245887] system 00:0e: iomem range 0x0-0x0 could not be reserved
[    0.245942] system 00:0e: iomem range 0x0-0x0 could not be reserved
[    0.245998] system 00:0e: iomem range 0x0-0x0 could not be reserved
[    0.246053] system 00:0e: iomem range 0x0-0x0 could not be reserved
[    0.246109] system 00:0e: iomem range 0x0-0x0 could not be reserved
[    0.246164] system 00:0e: iomem range 0x0-0x0 could not be reserved
[    0.246219] system 00:0e: iomem range 0x0-0x0 could not be reserved
[    0.246274] system 00:0e: iomem range 0x0-0x0 could not be reserved
[    0.246329] system 00:0e: iomem range 0x0-0x0 could not be reserved
[    0.246385] system 00:0e: iomem range 0x0-0x0 could not be reserved
[    0.246444] system 00:0f: iomem range 0x0-0x9ffff could not be reserved
[    0.246499] system 00:0f: iomem range 0xc0000-0xcffff has been reserved
[    0.246555] system 00:0f: iomem range 0xe0000-0xfffff could not be reserved
[    0.246611] system 00:0f: iomem range 0x100000-0xbfffffff could not be reserved
[    0.246675] system 00:0f: iomem range 0x0-0x0 could not be reserved
[    0.246724] system 00:0f: iomem range 0x0-0x0 could not be reserved
[    0.246785] system 00:0f: iomem range 0x0-0x0 could not be reserved
[    0.246840] system 00:0f: iomem range 0x0-0x0 could not be reserved
[    0.246895] system 00:0f: iomem range 0x0-0x0 could not be reserved
[    0.246950] system 00:0f: iomem range 0x0-0x0 could not be reserved
[    0.247006] system 00:0f: iomem range 0x0-0x0 could not be reserved
[    0.247062] system 00:0f: iomem range 0x0-0x0 could not be reserved
[    0.247117] system 00:0f: iomem range 0x0-0x0 could not be reserved
[    0.247172] system 00:0f: iomem range 0x0-0x0 could not be reserved
[    0.247227] system 00:0f: iomem range 0x0-0x0 could not be reserved
[    0.247282] system 00:0f: iomem range 0x0-0x0 could not be reserved
[    0.247338] system 00:0f: iomem range 0x0-0x0 could not be reserved
[    0.247393] system 00:0f: iomem range 0x0-0x0 could not be reserved
[    0.247448] system 00:0f: iomem range 0x0-0x0 could not be reserved
[    0.247503] system 00:0f: iomem range 0x0-0x0 could not be reserved
[    0.247558] system 00:0f: iomem range 0x0-0x0 could not be reserved
[    0.247614] system 00:0f: iomem range 0x0-0x0 could not be reserved
[    0.247669] system 00:0f: iomem range 0x0-0x0 could not be reserved

