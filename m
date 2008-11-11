Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbYKKPWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbYKKPWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 10:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756687AbYKKPW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 10:22:28 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:49699 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbYKKPW1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 10:22:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sA4ZDR/xnPxnp8qLR/qqWQ+/dUO4N4kBQ0w7mJ0suMOmczEz0/CMcr1CMUHTOvK7Ns
         rECl8wR6jgC+GDAH6bQ1dDgMjOFOCVzStPZAxKPW14eaR5yRQW6xVfdBt2+jHVZY2kg5
         pz3CfetbC2oRs4+YemtWGvLUG0VBFfz7Uhshk=
Message-ID: <dd18b0c30811110722v758a73b3gda76e1518ba49aa2@mail.gmail.com>
Date: Tue, 11 Nov 2008 07:22:24 -0800
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: [Bugme-new] [Bug 11717] New: Pressing suspend button suspends, but does not wakes up
Cc: "=?ISO-8859-1?Q?Rog=E9rio_Brito?=" <rbrito@ime.usp.br>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       linux-kernel@vger.kernel.org, yakui.zhao@intel.com,
       bugme-daemon@bugzilla.kernel.org, linux-pm@lists.linux-foundation.org,
       rjw@sisk.pl, acpi-bugzilla@lists.sourceforge.net, rui.zhang@intel.com
In-Reply-To: <20081111095333.GC5464@elf.ucw.cz>
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
	 <20081110141550.GB4450@ime.usp.br> <20081111095333.GC5464@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 1:53 AM, Pavel Machek <pavel@suse.cz> wrote:
> On Mon 2008-11-10 12:15:50, Rogério Brito wrote:
>> Hi, Pavel.
>>
>> On Nov 09 2008, Pavel Machek wrote:
>> > On Sun 2008-11-09 00:45:14, Rogério Brito wrote:
>> > > On Nov 08 2008, Justin Mattock wrote:
>> > > > On Fri, Nov 7, 2008 at 11:50 PM, Rogério Brito <rbrito@ime.usp.br> wrote:
>> > > > > I think that I have some more information regarding the
>> > > > > suspend/hibernate issue: with Ubuntu's 2.6.27 kernel, I can't
>> > > > > hibernate my laptop, but with vanilla 2.6.28-rc3, I can hibernate
>> > > > > (I have not tested it much, but it seems to work).
>>
>> I spoke too soon. Depending on what I do in userland (I tried using the
>> GNOME application "Cheese" just to put some load on the machine) and I
>> tried:
>>
>> # echo shutdown > /sys/power/disk
>> # echo disk > /sys/power/state
>>
>> But the machine stuck: it blanked the monitor, seemed to go to a console,
>> the cursor was blinking on the upper left corner of the screen, the HD
>> light blinked once and then the fan went faster, the CPU hotter and the
>> leds corresponding to caps lock and scroll lock were blinking.
>>
>> I'm waiting with the machine in this situation since I started composing
>> this e-mail and nothing has changed.
>>
>> The blinking leds (caps and scroll lock) would indicate a kernel panic, is
>> that correct?
>
> Yes, that's a panic. And we need text of that panic to do anything
> inteligent... Serial console? Try with different modules unloaded to
> see which one is that?
>
>
>> > Try it from the text console, and see what exactly stops
>> > responding. "killall klogd" is your friend.
>>
>> The funny thing is that once that I could resume, it resumed
>> instantly. :-( Weird.
>>
>>
>> Thanks, Rogério Brito.
>>
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>

if can, try and ssh into the machine then
suspend, then during wakeup see if you can collect any info.

-- 
Justin P. Mattock
