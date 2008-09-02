Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbYIBFHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbYIBFHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 01:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbYIBFG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 01:06:59 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:51555 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbYIBFG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 01:06:58 -0400
Date: Tue, 02 Sep 2008 01:06:22 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: Linux-2.6.27-rc5, drm errors in log
In-reply-to: <3f9a31f40809010934k468914d8sc43f323e9f32e9e7@mail.gmail.com>
To: "Jaswinder Singh" <jaswinderlinux@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jaswinder Singh" <jaswinder@infradead.org>, xorg@lists.freedesktop.org,
       davem@davemloft.net, torvalds@linux-foundation.org, nhaehnle@gmail.com,
       airlied@linux.ie, glisse@freedesktop.org, khali@linux-fr.org,
       tony@bakeyournoodle.com
Message-id: <200809020106.22494.gene.heskett@verizon.net>
Organization: Organization? Not detectable
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200808301452.04634.gene.heskett@verizon.net>
 <3f9a31f40809010934k468914d8sc43f323e9f32e9e7@mail.gmail.com>
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 September 2008, Jaswinder Singh wrote:
>Hello Gene,
>
>On Sat, Aug 30, 2008 at 2:52 PM, Gene Heskett <gene.heskett@verizon.net> 
wrote:
>> A re-repeat of a previous posting which has not drawn a comment. With
>> added content, added CC to a patch author, and some new questions.
>
>This is not because of my radeon firmware patch, my patch is still in
>pipeline. Here is the list of developers who played with radeon :-
>
>1. 4 days ago 	Linus Torvalds 	Merge branch 'drm-patches' of
>git://git.kernel.org ...
>2. 7 days ago 	Nicolai Haehnle 	drm/radeon: r300_cmdbuf: Always emit
>INDX_BUFFER immediately ...
>3. 7 days ago 	Jerome Glisse 	radeon: fix some hard lockups on r3/4/500s
>4. 2008-08-12 	David Miller 	radeonfb: fix accel engine hangs
>5. 2008-08-05 	Jean Delvare 	radeonfb: give i2c buses nicer names
>6. 2008-08-05 	David Miller 	radeon: misc corrections
>7. 2008-07-24 	Tony Breeds 	drivers/video/aty/radeon_base.c: notify
>user if sysfs ...
>
>> Machine is an F8 install, Athlon xp-2800 on an nforce2 motherboard,
>> running an older radeon 9200SE (RV280 based) video card.  No problems if I
>> reboot to 2.6.27-rc4.
>>
>> I'm drowning in these errors:
>>
>> Aug 30 13:21:05 coyote kernel: [14927.850078] [drm] wait for fifo failed
>> status : 0x80076100 0x00000000 Aug 30 13:21:05 coyote kernel:
>> [14927.861335] [drm] wait for fifo failed status : 0x80076100 0x00000000
>> Aug 30 13:21:05 coyote kernel: [14928.060233] [drm] wait idle failed
>> status : 0x80076100 0x00000000 Aug 30 13:21:07 coyote kernel:
>> [14929.557075] [drm] wait for fifo failed status : 0x80076100 0x00000000
>> Aug 30 13:21:07 coyote kernel: [14929.568869] [drm] wait for fifo failed
>> status : 0x80076100 0x00000000 Aug 30 13:21:08 coyote kernel:
>> [14931.028882] [drm] wait for fifo failed status : 0x80036100 0x00000000
>> Aug 30 13:21:08 coyote kernel: [14931.039896] [drm] wait for fifo failed
>> status : 0x80076100 0x00000000 Aug 30 13:21:18 coyote kernel:
>> [14940.515114] [drm] wait for fifo failed status : 0x80076100 0x00000000
>> Aug 30 13:27:27 coyote kernel: [15310.125656] [drm] wait for fifo failed
>> status : 0x80066107 0x00000000
>
>On F8 machine with radeon 9200SE with 2.6.27-rc5, I am also getting
>similar messages :
>
>[drm] Loading R200 Microcode
>[drm] writeback test succeeded in 1 usecs
>[drm] wait idle failed status : 0x83E8C13D 0x00000000
>[drm] wait idle failed status : 0x83E8C13D 0x00000000
>[drm] wait idle failed status : 0x83E8C13D 0x00000000
>[drm] wait idle failed status : 0x83E8C13D 0x00000000
>[drm] wait for fifo failed status : 0x8006613B 0x00000000
>[drm] wait for fifo failed status : 0x80066121 0x00000000
>[drm] wait for fifo failed status : 0x8006613B 0x00000000
>[drm] wait for fifo failed status : 0x80076100 0x00000000
>[drm] wait for fifo failed status : 0x80076100 0x00000000
>[drm] wait for fifo failed status : 0x80076100 0x00000000
>[drm] wait for fifo failed status : 0x80076100 0x00000000
>[drm] wait for fifo failed status : 0x80076100 0x00000000
>[drm] wait for fifo failed status : 0x80076100 0x00000000
>[drm] wait for fifo failed status : 0x80076100 0x00000000
>[drm] wait for fifo failed status : 0x80076100 0x00000000
>[drm] wait for fifo failed status : 0x80076100 0x00000000
>[drm] wait for fifo failed status : 0x80076100 0x00000000
>[drm] wait for fifo failed status : 0x80076100 0x00000000
>[drm] wait for fifo failed status : 0x80076100 0x00000000
>[drm] wait for fifo failed status : 0x80076100 0x00000000
>[drm] wait for fifo failed status : 0x80076100 0x00000000
>[drm] wait for fifo failed status : 0x80076100 0x00000000
>
>
>Thank you,
>
>Jaswinder Singh.

Dave Arlie has a patch that converts the DRM_INFO to DRM_DEBUG, which sticks a 
muffler on that.  Posted on lkml yesterday, it doesn't fix the problem but 
does shut it up.  The actual statement that causes that I put in every kernel 
back to 2.6.27-rc1, and they all do similar reports, so this is a long 
standing, and apparently mostly harmless bug.  I have seen zero screen 
corruption other than the terminals scrolling leaving trash '_' behind and 
has been for at least a year.

Thanks Jaswinder.
-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Winning isn't everything.  It's the only thing.
		-- Vince Lombardi
