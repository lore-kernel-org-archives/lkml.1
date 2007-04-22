Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbXDVLV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbXDVLV2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 07:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbXDVLV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 07:21:28 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:3633 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbXDVLV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 07:21:28 -0400
X-Greylist: delayed 1973 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Apr 2007 07:21:27 EDT
From: Martin Steigerwald <Martin@lichtvoll.de>
To: ck@vds.kolivas.org
Subject: Re: [ck] Re: Ten percent test
Date: Sun, 22 Apr 2007 12:48:30 +0200
User-Agent: KMail/1.9.6
Cc: Mike Galbraith <efault@gmx.de>, Ed Tomlinson <edt@aei.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux list <linux-kernel@vger.kernel.org>
References: <200703290237.38777.kernel@kolivas.org> <200704090726.01928.edt@aei.ca> <1176137433.6109.59.camel@Homer.simpson.net> (sfid-20070409_193902_186362_00CAB71C)
In-Reply-To: <1176137433.6109.59.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704221248.30758.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 09 April 2007 schrieb Mike Galbraith:
> On Mon, 2007-04-09 at 07:26 -0400, Ed Tomlinson wrote:
> > On Monday 09 April 2007 01:38, Mike Galbraith wrote:
> > > On Sun, 2007-04-08 at 09:08 -0400, Ed Tomlinson wrote:
> > > > Hi,
> > > >
> > > > I am one of those who have been happily testing Con's patches.
> > > >
> > > > They work better than mainline here.
> > >
> > > (I tried a UP kernel yesterday, and even a single kernel build
> > > would make noticeable hitches if I move a window around. YMMV etc.)
> >
> > Interesting.  I run UP amd64, 1000HZ, 1.25G, preempt off (on causes
> > kernel stalls with no messages - but that is another story).  I do
> > not notice a single make.   When several are running the desktop
> > slows down a bit.  I do not have X niced.  Wonder why we see such
> > different results?
>
> Probably because with your processor, in general cc1 can get the job
> done faster, as can X.  The latency big hit happens when you hit the
> end of the rotation.  You simply don't hit it as often as I do.  Anyone
> with an old PIII box should hit the wall very quickly indeed.  I
> haven't had time to try it here.

Hi!

I am running 2.6.20.7 + sd-0.44 on an IBM ThinkPad T23 that I use as my 
Amarok machine[1]. It  has a Pentium 3 with 1.13 GHz using ondemand 
frequency scaling and XFS as filesystem.

So far music playback has been perfect even when I had it building kernel 
packages while wildly clicking around starting apps and then moving the 
Amarok window like mad while solid window moving is enabled. Amarok / 
xine continued to play the music totally unimpressed of that.

So for me from a users point of view who wants good music playback *no 
matter what*, this is already perfect. Also the desktop feels quite 
snappy to me. It was only slow on anything I/O bound but thats 
understandable IMHO when make-kpkg tar -bzips the kernel source while 20 
KDE applications are starting and Amarok plays music.

Should I try any specific tests? This also goes out to anybody else, 
especially to you, Con.  So if you want me to run some benchmarks, please 
tell me. I am not experienced in benchmarking, but if you tell me what to 
do, I can try it out. I prefer benchmarks that do not disrupt music 
playback, but can run more aggressive benchmarks over night. I think it 
might be good to use a benchmark that isn't I/O bound to really test the 
scheduler... but as said I am no expert on that and real life loads 
usually are I/O bound as well.

Have to have an carefully eye on the harddisk though...

Apr 22 11:51:06 deepdance smartd[3116]: Device: /dev/sda, SMART Prefailure 
Attribute: 3 Spin_Up_Time changed from 154 to 150

(well threshold is at 033, so still plenty to go, hope it will take some 
time till the next change)

[1] http://martin-steigerwald.de/amarok-machine/ ;)

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
