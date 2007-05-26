Return-Path: <linux-kernel-owner+w=401wt.eu-S1762584AbXEZQTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762584AbXEZQTv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 12:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758453AbXEZQTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 12:19:44 -0400
Received: from mail.gmx.net ([213.165.64.20]:34143 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753783AbXEZQTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 12:19:42 -0400
X-Authenticated: #8359428
X-Provags-ID: V01U2FsdGVkX19HvEFfq0FHPOILh3JCTXP0+XVZLK9QCz1b2GGIKJ
	KNRMwyQVVG9WF7
From: Uwe Bugla <uwe.bugla@gmx.de>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Date: Sat, 26 May 2007 18:14:18 +0200
User-Agent: KMail/1.9.5
References: <20070524195616.234280@gmx.net> <200705261240.55153.uwe.bugla@gmx.de> <200705261750.48816.mb@bu3sch.de>
In-Reply-To: <200705261750.48816.mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705261814.18917.uwe.bugla@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 26. Mai 2007 17:50 schrieben Sie:
> Andrew,
>
> I am going to ignore Uwe from now on. It's simply impossible
> to debug the problem the way he is responding.
> Well, I'm not the first person in the Linux community adding
> him to the killfile, ... .
> I ask to try wireless-dev, as the driver works perfectly fine
> for me there, but he refuses to try it, too. So I'm stuck.

A. Where can I get wireless-dev, please?
B. Against what kernel can I apply it?
C. How must this stuff be applied?

Three clear questions, three clear answers please, if we want get forward.

Apart from that I do not owe a wireless device, and i more and more get the 
impression that you simply do not want to rework your code.
You rather search hungrily for excuses to point to some voluntary other side 
as soon as your code does not seem to work as expected and as soon as 
responsibilty issues are concerned.

So what tester would enjoy such a stubborn behaviour?
And additionally: Without getting paid for all the time effort?

> I already tried your -mm kernel, but it crashes on my machine
> for other reasons. (Yeah, I should look into them, too :P )
>
> Andrew, is it possible that the breakage was introduced in the
> merge process somehow? Didn't the patch apply cleanly? Are there
> other changes to b44 I should know about in your tree?

I think you can easily compare your wireless-dev code (where can I download 
it?) with the patch in the mm-tree. A simple diff will do I suppose.

>
> If it is really impossible to debug this problem, I'd like to
> suggest you to drop the b44-ssb port completely.
> I'm not going to destroy my nerves any further with guys like
> Uwe, so I'll include the b44-ssb port in the OpenWRT tree
> and be done with it.

As I stated already, debugging is not impossible!
In fact your responses didn't even mention real debugging as a choice.
To debug the issue I need the debug command line parametres for both ssb and 
b44. I cannot guess them, as there is no documentation available, neither for 
b44 nor for ssb. So what are the debug parametres please?

> Although I would be very sad about it, as my longterm goal was
> to make a vanilla kernel run on the OpenWRT devices... .

It is not my primary goal to leave you alone with this......

>
> But maybe we can get another tester for -mm with similiar problems,
> who is not bullshitting the whole time and is also going to
> test wireless-dev to make sure it's not a merge bug.

No, we need simply friendlier code developers without that immense arrogance 
behaviour that you show. That's it.

>
>
> -----------
>
> And Uwe: Remember, I am not payed for this. I do _all_ this
> in my free time.
> So sentences like: "So, the ball has been in your court
> for two days now, and you simply keep on hesitating
> to take action now."
> are _completely_ displaced in this discussion.

Yes. And I am doing this in my spare time too. And what I do not like is 
simply guessing around (ACPI bug, typo errors at DNS and nonsense like that 
etc.) plus this gesture going: "You are dumb, you are not understanding 
anything etc."

Cheers and happy reflection

Uwe

P. S.: My door is open, although the whole issue starts to nerve me due to 
your behaviour.
