Return-Path: <linux-kernel-owner+w=401wt.eu-S932270AbXCETUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270AbXCETUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 14:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932283AbXCETUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 14:20:33 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:59707 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270AbXCETUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 14:20:32 -0500
Date: Mon, 05 Mar 2007 14:19:25 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu
 scheduler
In-reply-to: <75b66ecd0703051020h1f0c1f85r15a5de082a80cec0@mail.gmail.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Lee Revell" <rlrevell@joe-job.com>,
       "Nicolas Mailhot" <nicolas.mailhot@laposte.net>
Message-id: <200703051419.25814.gene.heskett@gmail.com>
Organization: very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <54348.192.54.193.51.1173087934.squirrel@rousalka.dyndns.org>
 <200703050453.08154.gene.heskett@gmail.com>
 <75b66ecd0703051020h1f0c1f85r15a5de082a80cec0@mail.gmail.com>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2007, Lee Revell wrote:
>On 3/5/07, Gene Heskett <gene.heskett@gmail.com> wrote:
>> On Monday 05 March 2007, Nicolas Mailhot wrote:
>> >This looks like -mm stuff if you want it in 2.6.22
>>
>> This needs to get to 2.6.21, it really is that big an improvement.
>
>You can probably speed things up by regression testing against a wide
>range of non-desktop workloads and posting your numbers...
>
>Lee

I'm not THAT much of a tester other than seeing how it does my personal 
workload, such as working over an image in Gimp, and then printing it, 
while I'm reading and reply to email, browsing the web or playing 
solitaire.  At all of this is marches along rather nicely, and generally 
unaffected by the fetchmail/procmail/spamc loop every 90 seconds in the 
background.  glxgears runs about 1190 fps here, and loses maybe 4 or 5 
frames when the system beeps at me to indicate a new mail has arrived.  
Strangely, the wah wah wah wah it plays for a spam sent to trash doesn't 
bother glxgears any more then the 1/3 second beep.

I might add that its a bit puzzling to me, that when these pregnant pauses 
occur without the patch, gkrellm cpu usage, at an update frequency of 1 
second granularity, doesn't show ANY change, or so little it can't 
possibly explain why I'm sitting here for 10 seconds or more, waiting for 
what I've typed to actually show up on screen.  I should see a spike in 
one of the three cpu usage windows, but the whole thing is sitting at 2% 
total cpu while my application is starved and frozen for 10+ seconds at a 
time. 

That in itself tells this unwashed user that the scheduler is spinning its 
wheel somewhere as it exists today without this patch.  With this patch, 
those pauses are very small fractions of a second.  Just barely 
detectable.  And, system or user activity now properly registers in the 
gkrellm display, going up to about 15% user if I stand on the left arrow 
to backspace the cursor here in kmails composer screen.

To me, this plays great in Peoria, put it in ASAP and the users will bow 
at your feet to pay homage to Con for submitting it.

I am having a hard time figuring out why Con has thrown patches that might 
have helped over the fence only to have them go splat in the night.  When 
Con gets frustrated enough to post about it, everybody seems to turn a 
deaf ear, like he's committed some cardinal sin and I don't understand 
why or what.

This list is about development, supposedly in an orderly fashion, but 
occasionally a patch comes along that's so obviously correct it deserves 
to be fast tracked, and this is one of those.  To me this is as important 
as the filesystem corruption that was chased all the way thru from around 
2.6.17 to the middle of the 20-rc stuff.  Nobody wasted any time getting 
that into the next rc when it was finally found.  Fortunately I didn't 
get bit, possibly due to my habit of restarting azureas to seed, and I've 
seen it re-suck a few pieces to correct itself more than once.

Andrew, please, get this one in ASAP, but promise me an -mm won't trash 
half my filesystems like one I tried 2-3 years ago did.  Its a shame when 
Con submits a patch, and only 2 people post their experiences from using 
it.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
