Return-Path: <linux-kernel-owner+w=401wt.eu-S1760707AbXHaKu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760707AbXHaKu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 06:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758046AbXHaKuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 06:50:16 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:55643 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257AbXHaKuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 06:50:14 -0400
Message-ID: <46D7F0FE.2040306@gmail.com>
Date: Fri, 31 Aug 2007 12:44:14 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Tilman Sauerbeck <tilman@code-monkey.de>
CC: keith.packard@intel.com, Al Boldi <a1426z@gawab.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, airlied@linux.ie,
       Ingo Molnar <mingo@elte.hu>, dri-devel@lists.sourceforge.net,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: DRM and/or X trouble (was Re: CFS review)
References: <20070827204116.GA12495@elte.hu> <200708280737.53439.a1426z@gawab.com> <20070829041827.GA8733@elte.hu> <1188361749.21502.123.camel@koto.keithp.com> <20070829044614.GA13225@elte.hu> <1188374249.21502.155.camel@koto.keithp.com> <20070829080417.GB19386@elte.hu> <1188403075.21502.158.camel@koto.keithp.com> <46D5CF5F.6090505@gmail.com> <46D66C2D.3010900@gmail.com> <20070831064638.GA5315@code-monkey.de>
In-Reply-To: <20070831064638.GA5315@code-monkey.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2007 08:46 AM, Tilman Sauerbeck wrote:

>> On 08/29/2007 09:56 PM, Rene Herman wrote:

>>>> With X server 1.3, I'm getting consistent crashes with two glxgear
>>>> instances running. So, if you're getting any output, it's better than my
>>>> situation.
>>> Before people focuss on software rendering too much -- also with 1.3.0
>>> (and a Matrox Millenium G550 AGP, 32M) glxgears also works decidedly
>>> crummy using hardware rendering. While I can move the glxgears window
>>> itself, the actual spinning wheels stay in the upper-left corner of the
>>> screen and the movement leaves a non-repainting trace on the screen.
> 
> This sounds like you're running an older version of Mesa.
> The bugfix went into Mesa 6.3 and 7.0.

I have Mesa 6.5.2 it seems (slackware-12.0 standard):

OpenGL renderer string: Mesa DRI G400 20061030 AGP 2x x86/MMX+/3DNow!+/SSE
OpenGL version string: 1.2 Mesa 6.5.2

The bit of the problem sketched above -- the gears just sitting there in the 
upper left corner of the screen and not moving alongside their window is 
fully reproduceable. The bit below ... :

>>> Running a second instance of glxgears in addition seems to make both
>>> instances unkillable -- and when I just now forcefully killed X in this
>>> situation (the spinning wheels were covering the upper left corner of all
>>> my desktops) I got the below.

[ two kernel BUGs ]

... isn't. This seems to (again) have been a race of sorts that I hit by 
accident since I haven't reproduced yet. Had the same type of "racyness" 
trouble with keyboard behaviour in this version of X earlier.

> Running two instances of glxgears and killing them works for me, too.
> 
> I'm using xorg-server 1.3.0.0, Mesa 7.0.1 with the latest DRM bits from
> http://gitweb.freedesktop.org/?p=mesa/drm.git;a=summary

For me, everything standard slackware-12.0 (X.org 1.3.0) and kernel 2.6.22 DRM.

> I'm not running CFS though, but I guess the oops wasn't related to that.

I've noticed before the Matrox driver seems to get little attention/testing 
so maybe that's just it. A G550 is ofcourse in graphics-time a Model T by 
now. I'm rather decidedly not a graphics person so I don't care a lot but 
every time I try to do something fashionable (run Google Earth for example) 
I notice things are horribly, horribly broken.

X bugs I do not find very interesting (there's just too many) and the kernel 
bugs are requiring more time to reproduce than I have available. If the BUGs 
as posted aren't enough for a diagnosis, please consider the report withdrawn.

Rene.

