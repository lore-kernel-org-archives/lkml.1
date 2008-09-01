Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbYIAQej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbYIAQej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 12:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbYIAQeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 12:34:31 -0400
Received: from qb-out-0506.google.com ([72.14.204.233]:15318 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbYIAQea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 12:34:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VsRlDKpBjZR2mSS1Yh/R/DAZlk4tJn7txLFhRYz061QlB2pr7v/rF25K8GjxkbVlte
         sR0K2GqE/9THliEBTkj875Cp0Z1XlYc06Y1U1GunRdQSnGTMcopkA3M/BTVFN7hxEfZ0
         De27tGYrR4mhYQkXT2Y7nQKmNJH4+NCE/ECtQ=
Message-ID: <3f9a31f40809010934k468914d8sc43f323e9f32e9e7@mail.gmail.com>
Date: Mon, 1 Sep 2008 12:34:28 -0400
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: "Gene Heskett" <gene.heskett@verizon.net>
Subject: Re: Linux-2.6.27-rc5, drm errors in log
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jaswinder Singh" <jaswinder@infradead.org>, xorg@lists.freedesktop.org,
       davem@davemloft.net, torvalds@linux-foundation.org, nhaehnle@gmail.com,
       airlied@linux.ie, glisse@freedesktop.org, khali@linux-fr.org,
       tony@bakeyournoodle.com
In-Reply-To: <200808301452.04634.gene.heskett@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200808301452.04634.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Gene,

On Sat, Aug 30, 2008 at 2:52 PM, Gene Heskett <gene.heskett@verizon.net> wrote:
>
> A re-repeat of a previous posting which has not drawn a comment. With added
> content, added CC to a patch author, and some new questions.
>

This is not because of my radeon firmware patch, my patch is still in
pipeline. Here is the list of developers who played with radeon :-

1. 4 days ago 	Linus Torvalds 	Merge branch 'drm-patches' of
git://git.kernel.org ...
2. 7 days ago 	Nicolai Haehnle 	drm/radeon: r300_cmdbuf: Always emit
INDX_BUFFER immediately ...
3. 7 days ago 	Jerome Glisse 	radeon: fix some hard lockups on r3/4/500s
4. 2008-08-12 	David Miller 	radeonfb: fix accel engine hangs
5. 2008-08-05 	Jean Delvare 	radeonfb: give i2c buses nicer names
6. 2008-08-05 	David Miller 	radeon: misc corrections
7. 2008-07-24 	Tony Breeds 	drivers/video/aty/radeon_base.c: notify
user if sysfs ...

> Machine is an F8 install, Athlon xp-2800 on an nforce2 motherboard, running
> an older radeon 9200SE (RV280 based) video card.  No problems if I reboot
> to 2.6.27-rc4.
>
> I'm drowning in these errors:
>
> Aug 30 13:21:05 coyote kernel: [14927.850078] [drm] wait for fifo failed status : 0x80076100 0x00000000
> Aug 30 13:21:05 coyote kernel: [14927.861335] [drm] wait for fifo failed status : 0x80076100 0x00000000
> Aug 30 13:21:05 coyote kernel: [14928.060233] [drm] wait idle failed status : 0x80076100 0x00000000
> Aug 30 13:21:07 coyote kernel: [14929.557075] [drm] wait for fifo failed status : 0x80076100 0x00000000
> Aug 30 13:21:07 coyote kernel: [14929.568869] [drm] wait for fifo failed status : 0x80076100 0x00000000
> Aug 30 13:21:08 coyote kernel: [14931.028882] [drm] wait for fifo failed status : 0x80036100 0x00000000
> Aug 30 13:21:08 coyote kernel: [14931.039896] [drm] wait for fifo failed status : 0x80076100 0x00000000
> Aug 30 13:21:18 coyote kernel: [14940.515114] [drm] wait for fifo failed status : 0x80076100 0x00000000
> Aug 30 13:27:27 coyote kernel: [15310.125656] [drm] wait for fifo failed status : 0x80066107 0x00000000
>

On F8 machine with radeon 9200SE with 2.6.27-rc5, I am also getting
similar messages :

[drm] Loading R200 Microcode
[drm] writeback test succeeded in 1 usecs
[drm] wait idle failed status : 0x83E8C13D 0x00000000
[drm] wait idle failed status : 0x83E8C13D 0x00000000
[drm] wait idle failed status : 0x83E8C13D 0x00000000
[drm] wait idle failed status : 0x83E8C13D 0x00000000
[drm] wait for fifo failed status : 0x8006613B 0x00000000
[drm] wait for fifo failed status : 0x80066121 0x00000000
[drm] wait for fifo failed status : 0x8006613B 0x00000000
[drm] wait for fifo failed status : 0x80076100 0x00000000
[drm] wait for fifo failed status : 0x80076100 0x00000000
[drm] wait for fifo failed status : 0x80076100 0x00000000
[drm] wait for fifo failed status : 0x80076100 0x00000000
[drm] wait for fifo failed status : 0x80076100 0x00000000
[drm] wait for fifo failed status : 0x80076100 0x00000000
[drm] wait for fifo failed status : 0x80076100 0x00000000
[drm] wait for fifo failed status : 0x80076100 0x00000000
[drm] wait for fifo failed status : 0x80076100 0x00000000
[drm] wait for fifo failed status : 0x80076100 0x00000000
[drm] wait for fifo failed status : 0x80076100 0x00000000
[drm] wait for fifo failed status : 0x80076100 0x00000000
[drm] wait for fifo failed status : 0x80076100 0x00000000
[drm] wait for fifo failed status : 0x80076100 0x00000000
[drm] wait for fifo failed status : 0x80076100 0x00000000


Thank you,

Jaswinder Singh.
