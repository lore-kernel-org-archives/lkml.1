Return-Path: <linux-kernel-owner+w=401wt.eu-S1759673AbZEKVUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759673AbZEKVUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758564AbZEKVUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:20:04 -0400
Received: from mail1005.centrum.cz ([90.183.38.135]:50877 "EHLO
	mail1005.centrum.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450AbZEKVUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:20:03 -0400
Date: Mon, 11 May 2009 23:19:54 +0200
From: <trekker.dk@centrum.cz>
To: <pavel@ucw.cz>
Cc: <tuxonice-devel@lists.tuxonice.net>, <linux-pm@lists.linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
X-Mailer: Centrum Mail 5.0
MIME-Version: 1.0
X-Priority: 3
Message-ID: <200905112319.8749@centrum.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <20090507120948.GA1531@ucw.cz> <200905080037.19722@centrum.cz> <20090510053840.GG1363@ucw.cz>
In-Reply-To: <20090510053840.GG1363@ucw.cz>
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

______________________________________________________________
> Od: pavel@ucw.cz
> Komu: trekker.dk@centrum.cz
> CC: , linux-pm@liststuxonice-devel@lists.tuxonice.net.linux-foundation.org,linux-kernel@vger.kernel.org
> Datum: 11.05.2009 14:17
> Předmět: Re: [TuxOnIce-devel] [RFC] TuxOnIce
>
>On Fri 2009-05-08 00:37:39, trekker.dk@centrum.cz wrote:
>> Well...
>> 
>> >
>> >
>> >To summarise disadvantages:
>> >
>> >- only core has 8000 LoC
>> >- it does stuff that can be easily done in userspace
>> >     (and that todays distros _do_ in userspace).
>> >- it duplicates uswsusp functionality.
>> >- compared to [u]swsusp, it received little testing
>> >
>> 
>> To summarise advatages - for me tuxonice is the only hibernation method that works.
>> (Till now I've had 3 machines - no one of them able to resume with in-kernel swsusp.)
>> 
>
>Which kernels you tried, what hw it is? Can you do s2ram?
>									Pavel

Regarding hardware - 

1. AMD Athlon 1700+, VIA KT333 chipset based MB, nVidia GeForce 2
2. AMD X2 Athlon, AMD690V chipset based MB, nVidia 7600GT
3. (current) AMD X4 Phenom II,  AMD780G chipset and nVidia 9600GT 
(binary driver for video card every time)

Recently I tried kernels 2.6.26, 2.6.27 and now 2.6.29. Kernel 2.6.26 hibernated, but booted
up without recognizing image, so no attempt to resume was made.

Kernels 2.6.27 and 2.6.29 are able to resume, but thats about it - after resuming the box 
doesn't respond to keyboard and I have to reset it.

s2ram doesn't work as well. So far my best result is one succesful suspend/resume cycle; 
second attempt to do the same ended in black screen and the computer became "confused" -
reset (and I mean hardware reset with button on the case) didn't work - I had to turn it off
completely.

I have been using hibernation for quite some time (starting with kernel 2.6.14 or so) 
and never managed to get swsusp working. On the other hand tuxonice (and swsusp2
before the renaming) is - except for some glitches - working all that time.

I admit this is completely user's point of view, but I wanted to point out, that for some of us 
tuxonice is currenty way to go.

Regards
JB

>
>-- 
>(english) http://www.livejournal.com/~pavelmachek
>(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>

