Return-Path: <linux-kernel-owner+w=401wt.eu-S1752664AbZK0UJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbZK0UJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 15:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbZK0UJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 15:09:55 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:47938 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbZK0UJy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 15:09:54 -0500
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Nov 2009 15:09:54 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HIWOA0jMCum8OCDxgzzgzf2sNPxIhSQKm5yFXGKCekyMvjubkM9PF/tnQWGHdxkll5
         AIaC2SQ4UT7+5fqNjmrIKVfivD8HWmsU1HkXq4e2zGFQSZ8X5HtMlEKB9SlKiTCx3/j7
         2pfpbrqVuU/trJcdf+xKkdM7pB4lXRkaYowU8=
MIME-Version: 1.0
In-Reply-To: <200911270204.15100.rjw@sisk.pl>
References: <200911220015.30912.rjw@sisk.pl>
	 <21d7e9970911211955i69c12969n3085b6fc2c4a95f9@mail.gmail.com>
	 <200911270204.15100.rjw@sisk.pl>
Date: Fri, 27 Nov 2009 12:02:37 -0800
Message-ID: <dd18b0c30911271202m4487eb29jf7fa9fac7e3873bd@mail.gmail.com>
Subject: Re: Weird suspend/resume problem on HP nx6325 w/ openSUSE 11.2 w/ 
	-rc8
From: Justin Mattock <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dave Airlie <airlied@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       DRI <dri-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 5:04 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday 22 November 2009, Dave Airlie wrote:
>> On Sun, Nov 22, 2009 at 9:15 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > Hi,
>> >
>> > I'm not really sure where this should be reported, but here it goes.
>> >
>> > After installing openSUSE 11.2 on my testbed nx6325 I noticed that resume
>> > (from suspend to RAM) stopped working on it.  Apparently, it hanged while
>> > switching from the console back to X and the box remained completely
>> > unresponsive after that (it didn't even react to the magic sysrq).  However,
>> > it used to work just fine with -rc7 and openSUSE 11.1, so I figured the problem
>> > was related to the new X driver, which is radeon module version 6.12.4 (xorg
>> > server 1.6.5).
>> >
>> > So, I started to investigate and found that after a suspend from a framebuffer
>> > console, the resume had always worked.  However, when I switched from X to the
>> > framebuffer console, suspended, resumed and switched back to X, the box hanged
>> > immediately just like during resume after a suspend from under X.  [There also
>> > were some problems when switching from X to the framebuffer console and back
>> > which seemd to be independent of suspend/resume (in short, the screen stays
>> > black after a switch from the framebuffer console to X and you need to kill X
>> > to fix this).]
>>
>> You are using radeonfb on it? or vesafb?
>
> vesafb
>
>> first test is to try without either of those installed.
>
> That doesn't change the behavior AFAICS.
>
>> From memory though that machines an Xpress 200M
>
> Yes, it has this one.
>
>> which is the the worst graphics card for use with open drivers and has
>> always caused no-end of pain.
>
> Too bad. :-(
>
>> Its also mostly undocumented when it comes to errata and workarounds.
>
> Well, so I guess this is a hardware errata.
>
> Still, it worked with the older X, so I wonder if I can make the new X work
> like the old one?
>
> Best,
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

>From over here I was running the stable kernel
on a freshly built clfs system, with the latest xorg from git
suspend worked as is. Then loading the latest git kernel
noticed the lagging of the wake up. When I get a chance I'll
do a bisect and see If I come up with anything.


-- 
Justin P. Mattock
