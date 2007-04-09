Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbXDISgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbXDISgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 14:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbXDISgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 14:36:45 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:59429 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbXDISgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 14:36:44 -0400
Date: Mon, 09 Apr 2007 14:36:18 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: I give up
In-reply-to: <461A71FA.40900@zytor.com>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Jeff Garzik <jeff@garzik.org>
Message-id: <200704091436.18986.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200704091007.58535.gene.heskett@gmail.com>
 <Pine.LNX.4.61.0704091848150.21426@yvahk01.tjqt.qr> <461A71FA.40900@zytor.com>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 April 2007, H. Peter Anvin wrote:
>Jan Engelhardt wrote:
>> dm is on 254 for me.. in opensuse with a 2.6.20 that is. I wonder why
>> it even moves around. However, even then, those who use udev and
>> device names rather than (major,minor) tuples should not have any
>> problem.
>
>It moves around because someone at some point thought it was a great
>idea to assign dynamic majors to core functionality.
>
>It stays put at 254 for you since that's the highest (and thus
>first-used) dynamic major.
>
>	-hpa

Until I also build pkdcdvd or md, each of which shove it down the list.

Now, as an update here at the coyote.den, fixing the typu in 
my /etc/modprobe.conf (Daves original message used dm_mod in the sample 
and it should have been dm-mod) and another rebuild/install cycle, and it 
is now at the LANANA assigned address that the patch which was reverted 
put it at, 238=EE and EE00h=60928.  Now all we have to do is write a 
script to fix the reference files tar is given for incremental detection 
so that the device number is corrected to the current device as reported 
by a 'stat /' command.

However, there seems to be a  wholesale conviction that the files are 
encrypted or otherwise smunched, they are not, but absolutely plain text:
[amanda@coyote gnutar-lists]$ cat coyote_var_5
1175495769
60928 19169380 ./run/cups
60928 19300353 ./cache/gstreamer-0.8
60928 19169448 ./lib/scrollkeeper/az
60928 19595604 ./tmp/RealPlayer/share/locale/ko
60928 19300370 ./cache/yum/updates-source
60928 19169358 ./cache/man/local
60928 19235048 ./tmp/kdecache-root/background
60928 19988737 ./tmp/kdecache-root/kio_help/root/.kde/share/doc
60928 19791895 ./spool/cups-pdf

So writing a script that compares that first number to one of the FE, FD, 
FC variations and corrects it to the EE value as converted above should 
be relatively trivial and I'll try to do that yet today, but there are a 
couple of honeydo's to take care of first.



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Don't talk to me about naval tradition.  It's nothing but rum, sodomy and
the lash.
	-- Winston Churchill
