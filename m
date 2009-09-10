Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbZIJMCc (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 10 Sep 2009 08:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbZIJMCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 08:02:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:47949 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751996AbZIJMCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 08:02:30 -0400
X-Authenticated: #8143315
X-Provags-ID: V01U2FsdGVkX19gaJRIl9JgKAsRiv1qZsTDP6PS15VVvwW/jJnChk
	0FTDPKpKMvi/IG
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
   "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Cc: "Kernel Testers List" <kernel-testers@vger.kernel.org>,
   "Dave Airlie" <airlied@redhat.com>,
   "Jerome Glisse" <glisse@freedesktop.org>,
   =?utf-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
   "Shaohua Li" <shaohua.li@intel.com>
Subject: Re: [Bug #13318] AGP doesn't work anymore on nforce2
References: <aIL9jMAYJnG.A.WjH.M3BpKB@chimera>
 <hKF51Pczj6N.A.2PB.55BpKB@chimera>
Date: Thu, 10 Sep 2009 14:02:29 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
FROM: Karsten Mehrhoff <kawime@gmx.de>
Message-ID: <op.uz1iefpygp7xae@127.0.0.1>
In-Reply-To: <hKF51Pczj6N.A.2PB.55BpKB@chimera>
User-Agent: Opera Mail/10.10 (Linux)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today i compilied the new kernel 2.6.31 and everything works ok.
Maybe it's related to other changes in the generic.c file.

So everything works ok for me with AGP in 2.6.31.
I do not get the problem like it was in 2.6.30.x


2.6.31:
=======
$ dmesg | grep agp
[    0.668878] Linux agpgart interface v0.103
[    0.669457] agpgart: Detected NVIDIA nForce2 chipset
[    0.674984] agpgart-nvidia 0000:00:00.0: AGP aperture is 64M @  
0xe0000000
[   35.184416] agpgart-nvidia 0000:00:00.0: AGP 3.0 bridge
[   35.184437] agpgart-nvidia 0000:00:00.0: putting AGP V3 device into 8x  
mode


$ dmesg | grep drm
[    0.675940] [drm] Initialized drm 1.1.0 20060810
[    0.678840] [drm] Initialized radeon 1.31.0 20080528 for 0000:02:00.0  
on minor 0
[   35.460115] [drm] Setting GART location based on new memory map
[   35.460125] [drm] Loading R300 Microcode
[   35.460170] [drm] Num pipes: 1
[   35.460178] [drm] writeback test succeeded in 1 usecs


-Karsten-


[Am 06.09.2009, 20:11 Uhr, schrieb Rafael J. Wysocki <rjw@sisk.pl>]

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13318
> Subject		: AGP doesn't work anymore on nforce2
> Submitter	: Karsten Mehrhoff <kawime@gmx.de>
> Date		: 2009-04-30 8:51 (130 days old)
> First-Bad-Commit:  
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=59de2bebabc5027f93df999d59cc65df591c3e6e
> References	: http://marc.info/?l=linux-kernel&m=124108156417560&w=4
> Handled-By	: Shaohua Li <shaohua.li@intel.com>
>
