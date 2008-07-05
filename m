Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717AbYGEOAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbYGEOAh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 10:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbYGEOA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 10:00:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:40220 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbYGEOA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 10:00:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=sgHQa1oSO0INfTppSSQOCoI/zZymVyxLiRjBdghZ3SkghjhVag1Rl8u/vEpwOvaYkk
         5pDsmkGQQLs3LaEup2YqFHl2nCz1dJGWOpZhTtNR6brO2qr50lvYHb6lcBJlxRKZKKGV
         ot3KmvofhcpbxSpB82H1EJrqPiS5QrQBD62hY=
Message-ID: <31e679430807050700q765dc45ft198fcf1c0b91a9cc@mail.gmail.com>
Date: Sat, 5 Jul 2008 17:00:26 +0300
From: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
To: "Theodore Tso" <tytso@mit.edu>,
       "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       "Kernel development list" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: Battery life difference
In-Reply-To: <20080705133601.GA20240@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <31e679430807050617u3fc706fasee9bb43a151c501f@mail.gmail.com>
	 <20080705133601.GA20240@mit.edu>
X-Google-Sender-Auth: 81b5a32b7a501fad
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jul 5, 2008 at 4:36 PM, Theodore Tso <tytso@mit.edu> wrote:
> You didn't say which battery you are using; I'm guessing you are using
> the 4 cell slim-line battery, which is rated at 28.8 Watt-hours?

yeah, the normal slim-battery.

> How many Watts is Powertop reporting that you are using?  I'm down to

eheh, it's only 15.5w :-p

> around 8-9 watts, and around 9.5 watts in "airplane mail reading mail"
> (wireless disabled, USB modules unloaded, screen brightness turned way
> down, laptop_mode enabled, all mail messages pulled into memory, and
> reading/deleting mail using mutt, a character-mode based mail reader
> --- if you use Evolution, your energy usage will definitely be higher  :-).

no crappy evolution, I use fluxbox and mutt. This ubuntu machine is
for testing purposes only :-p

Anyways, it's bad that we have to manually unload several modules,
specially usb. I'm sure windows reaches 9 watts consumption without
breaking functionality. And that's the big thing. I think that's something
we should be aiming. Dontcha think?

> See http://thunk.org/tytso/blog/2007/10/29/tip-o-the-hat-wag-o-the-finger-linux-power-savings-for-laptop-users/

Good article, but still. On the end user point of view, it's difficult to do
rmmod/insmod operations. Recently I sent a patch to the bluez team
adding a checkbox to bluetooth-properties that would send the SetMode("off")
dbus message (which is the same as running hciconfig hci0 down).

That helps a bit, but still the driver is not been used and keeps generating
wakeup events. Why if it's not been used ?

Maybe this is something we should start thinking about, right ?

-- 
Best Regards,

Felipe Balbi
felipebalbi@users.sourceforge.net
