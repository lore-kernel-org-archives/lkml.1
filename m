Return-Path: <linux-kernel-owner+w=401wt.eu-S936774AbYEURry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936774AbYEURry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933759AbYEURr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:47:26 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:14255 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855AbYEURrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:47:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=S8VRq466mVnYN7paFD2aGSdJhCCCR5mJkVi6xYUfqBR9NQy10MPJ5ICNKpFfWMYkNONdb/eAf5v57ZHtBwXKpP4fyPsNO6zUsH0OxxNqPyUjoJpdk/3VgRSGX5BuOEyE4VP99WqTj1YG33b814/9Z7tdvAsoy17FWJEx7Z10WdQ=
Message-ID: <48346018.5040800@googlemail.com>
Date: Wed, 21 May 2008 19:47:04 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org
Subject: linux-next: sound/pcmcia/vx build error
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got the following error with a randconfig on linux-next-20080521

...

sound/built-in.o: In function `vxpocket_detach':
vxpocket.c:(.text+0x20cfa): undefined reference to `pcmcia_disable_device'
sound/built-in.o: In function `vxpocket_probe':
vxpocket.c:(.text+0x20f46): undefined reference to `pcmcia_request_io'
vxpocket.c:(.text+0x20f5a): undefined reference to `pcmcia_request_irq'
vxpocket.c:(.text+0x20f73): undefined reference to `pcmcia_request_configuration'
vxpocket.c:(.text+0x2101f): undefined reference to `cs_error'
vxpocket.c:(.text+0x21027): undefined reference to `pcmcia_disable_device'
sound/built-in.o: In function `init_vxpocket':
vxpocket.c:(.init.text+0x75b): undefined reference to `pcmcia_register_driver'
sound/built-in.o: In function `exit_vxpocket':
vxpocket.c:(.exit.text+0x28c): undefined reference to `pcmcia_unregister_driver'
make: *** [.tmp_vmlinux1] Error 1

...


config -> http://frugalware.org/~crazy/linux-next/randconfig/bad33_config


Regards,

Gabriel
