Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbZLUSMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbZLUSMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 13:12:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbZLUSMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 13:12:38 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:52202 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbZLUSMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 13:12:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KjyjQN/ujxmuXOY6mW/AFRquwa3QpHQhaG4FclJMA3EyVen96EVQIPWlmZb1pN2IZq
         2Xb5CzmDz3j1pikzp8n2x/Os+0dlgWCI3hr4R5qu8YUgj84wzMdFiTfYEJhEFW7iXt6e
         kO13y/CQ8v1cCWjaPi0rLgNksf8Trc4ThpuG4=
MIME-Version: 1.0
In-Reply-To: <s5hmy1cpqo4.wl%tiwai@suse.de>
References: <8db1092f0912200927y7cdab36ftd1f73d56cd89763f@mail.gmail.com>
	 <s5hmy1cpqo4.wl%tiwai@suse.de>
Date: Mon, 21 Dec 2009 19:12:34 +0100
Message-ID: <8db1092f0912211012mcdd6639oaaf0bddc118e7d66@mail.gmail.com>
Subject: Re: [2.6.33-rc1] [SOUND] HDA: high cpu usage, noise
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org, perex@perex.cz,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/21 Takashi Iwai <tiwai@suse.de>:
> At Sun, 20 Dec 2009 18:27:45 +0100,
> Maciej Rutecki wrote:
>>
>> Hi
>>
>> Affected kernel: 2.6.33-rc1
>> Last known good: 2.6.32
>
> The only fundamental change, AFAIK, is the use of MSI as default.
> Could you try to add enable_msi=0 option to snd-hda-intel?
>

root@gumis:/# cat /sys/module/snd_hda_intel/parameters/enable_msi
0

Still the same:
ps aux:

root      1117 27.4  0.0      0     0 ?        S    19:00   2:05 [hd-audio0]

I also notice short sound during booting system, when sound modules is
loading.  I can try bisection, but in next week; already I don't have
to much time.

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
