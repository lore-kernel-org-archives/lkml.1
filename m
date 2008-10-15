Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbYJOHNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbYJOHNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 03:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbYJOHNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 03:13:35 -0400
Received: from styx.suse.cz ([82.119.242.94]:32936 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751789AbYJOHNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 03:13:34 -0400
Date: Wed, 15 Oct 2008 09:13:32 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Adrian Bunk <bunk@kernel.org>
cc: Jiri Slaby <jirislaby@gmail.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: usbhid_set_leds problems
In-Reply-To: <20081015050557.GB20183@cs181140183.pp.htv.fi>
Message-ID: <alpine.LNX.1.10.0810150912500.26779@jikos.suse.cz>
References: <20081015041346.GE4710@cs181140183.pp.htv.fi> <20081015050557.GB20183@cs181140183.pp.htv.fi>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008, Adrian Bunk wrote:

> >   LD      .tmp_vmlinux1
> > drivers/built-in.o: In function `bright_probe':
> > drivers/hid/hid-bright.c:38: undefined reference to `usbhid_set_leds'
> > drivers/hid/hid-bright.c:38: undefined reference to `usbhid_set_leds'
> > drivers/built-in.o: In function `dell_probe':
> > drivers/hid/hid-dell.c:41: undefined reference to `usbhid_set_leds'
> > drivers/hid/hid-dell.c:41: undefined reference to `usbhid_set_leds'
> > drivers/built-in.o: In function `lg_probe':
> > drivers/hid/hid-lg.c:252: undefined reference to `usbhid_set_leds'
> > drivers/hid/hid-lg.c:252: more undefined references to `usbhid_set_leds' follow
> > ...
> > make[1]: *** [.tmp_vmlinux1] Error 1
> > And I'm not sure commit 6edfa8dc33803a49ad936ead9840e453bee6ca3b
> > (HID: move reset leds quirk) was a good idea at all since I don't
> > see cases like HID_DELL=y, CONFIG_USB_HID=m could now work at all.
> Scrap that mail, I shouldn't send patches before the first cup of tea...
> I just found the actual problem.

Hmm, so what was the culprit actually? The build error shouldn't be there.

Thanks,

-- 
Jiri Kosina
SUSE Labs
