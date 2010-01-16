Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab0APRxi (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 12:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390Ab0APRxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 12:53:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755252Ab0APRxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 12:53:36 -0500
Date: Sat, 16 Jan 2010 19:48:22 +0200
From: m.s.tsirkin@gmail.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Adrian Bunk <bunk@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Natalie Protasevich <protasnb@gmail.com>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.ker>
Subject: Re: 2.6.33-rc2: Reported regressions from 2.6.32
Message-ID: <20100116174821.GA18306@redhat.com>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 29, 2009 at 04:05:30PM +0100, Rafael J. Wysocki wrote:
> [NOTES:
>  * There you go, another round of tracking regressions.  It's not too bad at
>    the moment, as far as the regressions from 2.6.32 are concerned, but we have
>    quite a few -stable regressions, apparently in the DRI area.

I have another one there :)

Immediately upon startup, screen is flickering (becomes
lighter and darker again). The problem occurs with kernels
2.6.33-rc1 to 2.6.33-rc4, but not with kernel 2.6.32 and below.

System details:
x86_64 kernel with 32 bit Fedora 11 userspace
kernel modesetting enabled.

dri2proto  dri2proto-2.2
drm  2.4.17-23-g06a2d65
macros  util-macros-1.4.1-4-g43e41a5
xf86-video-intel  2.10.0-13-g96f45c6

mesa versions(from glxinfo):
server glx version string: 1.2
client glx version string: 1.4
GLX version: 1.2
OpenGL version string: 2.1 Mesa 7.6-devel
OpenGL shading language version string: 1.20

X.Org X Server 1.6.3.901 (1.6.4 RC 1)


Hardware: lenovo thinkpad T500 with integrated intel graphics.

00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory
Controller Hub (rev 07)
00: 86 80 40 2a 06 01 90 20 07 00 00 06 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 e0 20
30: 00 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00

00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series
Chipset
Integrated Graphics Controller (rev 07)
00: 86 80 42 2a 07 04 90 00 07 00 00 03 00 00 80 00
10: 04 00 40 f4 00 00 00 00 0c 00 00 d0 00 00 00 00
20: 01 18 00 00 00 00 00 00 00 00 00 00 aa 17 e4 20
30: 00 00 00 00 90 00 00 00 00 00 00 00 0b 01 00 00

00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset
Integrated Graphics Controller (rev 07)
00: 86 80 43 2a 07 00 90 00 07 00 80 03 00 00 80 00
10: 04 00 20 f4 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 e4 20
30: 00 00 00 00 d0 00 00 00 00 00 00 00 00 00 00 00

Display adapter: integrated LVDS1.

How to reproduce: start X, observe flickering

Filed it here with X log/dmesg/xrandr/intel_reg_dump output:
https://bugs.freedesktop.org/show_bug.cgi?id=26037
(from past experience, http://bugzilla.kernel.org/ reports
 seem to have been ignored).

-- 
MST
