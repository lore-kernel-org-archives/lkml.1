Return-Path: <linux-kernel-owner+w=401wt.eu-S966333AbXDGUae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966333AbXDGUae (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 16:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966337AbXDGUae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 16:30:34 -0400
Received: from vms040pub.verizon.net ([206.46.252.40]:57902 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966333AbXDGUac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 16:30:32 -0400
Date: Sat, 07 Apr 2007 16:30:25 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Ten percent test
In-reply-to: <20070407185220.GA31725@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
Message-id: <200704071630.25830.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703290237.38777.kernel@kolivas.org>
 <200704071423.47790.gene.heskett@gmail.com> <20070407185220.GA31725@elte.hu>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 April 2007, Ingo Molnar wrote:
>* Gene Heskett <gene.heskett@gmail.com> wrote:
>> Yes it would be Ingo, but so far, none of the recent -rt patches has
>> booted on this machine, the last one I tried a few days ago failing to
>> find /dev/root, whatever the heck that is.
>
>did you have a chance to try the yum kernel by any chance? The -testing
>one you can try on Fedora with little hassle, by doing this as root:
>
>cat > /etc/yum.repos.d/rt-testing.repo
>[rt-testing]
>name=Ingo's Real-Time (-rt) test-kernel for FC6
>baseurl=http://people.redhat.com/mingo/realtime-preempt/yum-testing/yum/
>enabled=1
>gpgcheck=0
><Ctrl-D>
>
>and "yum install kernel-rt" and a reboot should get you going.

No, I couldn't seem to get that to show up in a yumex display, and I'm 
partial to smart anyway.

>> [...]  I don't enjoy sitting through all these e2fsk's during the
>> reboot just to have things I normally run in the background die, like
>> tvtime, sitting there with some news channel muttering along in the
>> background.  I was even ignored when I suggested it might be a dma
>> problem, which I still think it could be.
>
>i did spend quite some time to debug your tv-tuner problem back then,
>and for that purpose alone i bought a tv tuner card to test this myself.
>(but it worked on my testbox)
>
>	Ingo
You didn't tell me this.

That said, I am booted to the patch you sent me now, and this also is a 
very obvious improvement, one I could easily live with on a long term 
basis.  I haven't tried a kernel build in the background yet, but I have 
sat here and played patience for about an hour, looking for the little 
stutters, but never saw them.  So I could just as easily recommend this 
one for desktop use, it seems to be working.  tvtime hasn't had any audio 
or video glitches that I've noted when I was on that screen to check on 
an interesting story, like the 102 year old lady who finally got her hole 
in one, on a very short hole, but after 90 years of golfing, she was 
beginning to wonder if she would ever get one.  Not sure who bought at 
the 19th hole, HNN didn't cover that traditional part.

So this patch also works.  And if it gets into mainline, at least Con's 
efforts at proding the fixes needed will not have been in vain.

My question then, is why did it take a very public cat-fight to get this 
looked at and the code adjusted?  Its been what, nearly 2 years since 
Linus himself made a comment that this thing needed fixed.  The fixes 
then done were of very little actual effectiveness and the situation then 
has gradually deteriorated since.

Its on the desktop that linux will win or lose the public's market share.  
After all, there are only so many 'servers' on the planet, a market that 
linux has pretty well demo'ed its superiority, if not in terms of speed, 
at least in security.

To qualify that, I currently have 2 of yahoo's machines in 
my .procmailrc's /dev/null list as they are a source of a large number of 
little 1 to 3 line spams.  I assume they are IIS machines, but the emails 
headers aren't that explicit to my relatively untrained eyeballs.

And I'd like to see korea put on a permanent rbl black hole.  I'm less 
than amused at watching the log coming out of my router as first one 
shithead and then the next makes a 100,000 word dictionary attack against 
it.  One has even found a way too cause a tcp reset about every 10 words 
tried.  But nobody has gotten any farther than that.  That knocking 
sound?  Guess.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
You are magnetic in your bearing.
