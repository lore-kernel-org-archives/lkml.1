Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555AbYKJPBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbYKJPBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 10:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbYKJPBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 10:01:03 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:6226 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbYKJPBB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 10:01:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lKWqDG5eNAnTXQ9uaEb47KtI9LN0bKYUZELwME6EjiXqgpPTeD7ZeBJXARBrDGd/Ta
         KTxjcwG0EDVTPXXdivMIaDw3HmomWgRTo/AYEJu+q2voIO3DnaqCQi6Bb4Q3iwim1oFD
         kswHe927UPBrJNtnxDzqUCVxJps9mLDDwczEI=
Message-ID: <dd18b0c30811100700y7922ce37y8ba39ba7b43031b3@mail.gmail.com>
Date: Mon, 10 Nov 2008 07:00:59 -0800
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: [Bugme-new] [Bug 11717] New: Pressing suspend button suspends, but does not wakes up
Cc: "Rog?rio Brito" <rbrito@ime.usp.br>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       linux-kernel@vger.kernel.org, yakui.zhao@intel.com,
       bugme-daemon@bugzilla.kernel.org, linux-pm@lists.linux-foundation.org,
       rjw@sisk.pl
In-Reply-To: <20081110074516.GB707@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20081106194724.GB15366@ime.usp.br>
	 <20081107014535.GA19201@ime.usp.br>
	 <1226044855.4913f5b7f2f45@webmail.ime.usp.br>
	 <20081108075008.GA8177@ime.usp.br>
	 <dd18b0c30811080020i23418742xc6388a5942456566@mail.gmail.com>
	 <20081109024514.GA11744@ime.usp.br> <20081109113332.GD6094@elf.ucw.cz>
	 <dd18b0c30811092117mc7bd310kaac33f5b1ff0a61d@mail.gmail.com>
	 <20081110074516.GB707@atrey.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/9 Pavel Machek <pavel@suse.cz>:
>> On Sun, Nov 9, 2008 at 3:33 AM, Pavel Machek <pavel@suse.cz> wrote:
>> > On Sun 2008-11-09 00:45:14, Rogério Brito wrote:
>> >> Hi, Justin and others.
>> >>
>> >> On Nov 08 2008, Justin Mattock wrote:
>> >> > On Fri, Nov 7, 2008 at 11:50 PM, Rogério Brito <rbrito@ime.usp.br> wrote:
>> >> > > I think that I have some more information regarding the suspend/hibernate
>> >> > > issue: with Ubuntu's 2.6.27 kernel, I can't hibernate my laptop, but with
>> >> > > vanilla 2.6.28-rc3, I can hibernate (I have not tested it much, but it
>> >> > > seems to work).
>> >>
>> >> Just some extra information here: while I can hibernate with vanilla
>> >> 2.6.28-rc3, upon resuming, it takes *minutes* (I don't know how many
>> >> minutes, but probably something like 5 minutes or so!) for the desktop to
>> >> have any effect (despite the fact that I can move the mouse without any
>> >> problems).
>> >
>> > Try it from the text console, and see what exactly stops
>> > responding. "killall klogd" is your friend.
>>
>> FWIW, running radeon and s2ram
>> gives me a successful wakeup,
>> no delays only bluetooth-applet fails
>> to show back up as eye candy.
>
> So 2.6.28-rc3 actually works for you? Good ;-).
>                                                                        Pavel
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>

yes to my surprise  ; )
using the manual(echo mem > /sys/power/state)
approach is not so good though
i.g. black screen when waking up
for a few seconds, then a automatic reboot.
Anyways I figured this was a new video driver and
so forth, so its just a matter of time before
the module gets more refined.

-- 
Justin P. Mattock
