Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbXLNOnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbXLNOnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 09:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbXLNOnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 09:43:05 -0500
Received: from mail.polimi.it ([131.175.12.3]:50334 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591AbXLNOnD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 09:43:03 -0500
From: stefano.brivio@polimi.it
Message-ID: <20071214154022.v5w0eqwwiogws8cw@webmail.polimi.it>
Date: Fri, 14 Dec 2007 15:40:22 +0100
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ingo Molnar <mingo@elte.hu>, Daniel Walker <dwalker@mvista.com>,
       Ray Lee <ray-lk@madrabbit.org>, matthias.kaehlcke@gmail.com,
       linux-kernel@vger.kernel.org, mbuesch@freenet.de, linux@bohmer.net,
       Michael Buesch <mb@bu3sch.de>, kjwinchester@gmail.com,
       jonathan@jonmasters.org, akpm@linux-foundation.org,
       bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore
	to mutex
References: <20071213003028.676998182@mvista.com>
	<200712131445.39770.mb@bu3sch.de>
	<2c0942db0712131604m41c34da9hf3122b0603f3af96@mail.gmail.com>
	<200712140143.16451.mb@bu3sch.de> <20071214105624.GC23964@elte.hu>
	<20071214141446.GA3096@tuxdriver.com>
In-Reply-To: <20071214141446.GA3096@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.5)
X-PMX-Version: 5.3.3.310218, Antispam-Engine: 2.5.2.311128, Antispam-Data: 2007.12.14.61522
X-PerlMx-Spam: Gauge=IIIIIII, Probability=7%, Report='NO_REAL_NAME 0, __CD 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"John W. Linville" <linville@tuxdriver.com> wrote:

> On Fri, Dec 14, 2007 at 11:56:24AM +0100, Ingo Molnar wrote:
>>
>> * Michael Buesch <mb@bu3sch.de> wrote:
>
>> > Oh come on. b43 is more than a year old now. How long should we wait?
>> > Two or three? Forever?
>>
>> possibly forever, if you dont get obvious regressions like "my wlan does
>> not work" (reported in this very thread), resolved. Pushing the blame to
>> udev (in a rather unfriendly way) wont give users a working system and
>> wont get you many new testers for the new driver either.
>
> It is true that Michael can be a little unpleasant at times.
> The colloquialism that comes to mind is that he "does not suffer fools
> lightly".  Hopefully he will take your counseling to heart and learn
> to be a bit more moderate in his tone.  FWIW, he is still young. :-)

No way. He's just inhuman. :P

> That said, it is also true that the b43[legacy] driver[s] do a more
> than adequate job of replacing the old bcm43xx driver provided that
> one (re-)installs the proper firmware.  And I know of no other driver
> that goes to more trouble to tell you how to get the proper firmware
> installed than this one.
>
> The bcm43xx driver will be added to the feature removal schedule
> in 2.6.25.  Proper judgment will be used in deciding the actual date
> of its removal.  In the meantime hopefully every distribution will
> have or obtain a working udev configuration.  If things don't work
> out as planned then we will re-evaluate.
>
> Let's stop this now please.

Agreed. As a b43legacy maintainer, I'd be happy to know if Ingo  
suggests other ways to smooth out the transition. I haven't read  
proposals yet.


--
Ciao
Stefano



