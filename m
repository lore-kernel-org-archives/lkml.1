Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbZLEK4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbZLEK4P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 05:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbZLEK4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 05:56:13 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:43907 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbZLEK4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 05:56:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lQZ/D8bJTC2sfluMtALqNYjz9L+Ry3HnxA7qL41ar5HWUWjVSwV6D9iX4pbVYZaBQG
         LfqUYmj9tNp6T4NG62lIK8k+pIzvoWak1fjZP6En/Is+CWm/illga4LziyO3RV4ir0Kk
         KHfZ23hPuDHIWPqGZi7nX2d80oS7i9KbR7yOE=
Message-ID: <4B1A3C13.4060204@gmail.com>
Date: Sat, 05 Dec 2009 12:55:15 +0200
From: Lior Dotan <liodot@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091201)
MIME-Version: 1.0
To: Andy Isaacson <adi@hexapodia.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.32-rc8 - T500 fails to suspend to RAM
References: <4B151FE2.3090807@gmail.com> <20091203182336.GA21309@hexapodia.org> <20091204202433.GB21309@hexapodia.org> <a5bf86a80912041339g3d35cbfcrd56669f746d095ff@mail.gmail.com> <20091204234459.GC25713@hexapodia.org>
In-Reply-To: <20091204234459.GC25713@hexapodia.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Isaacson wrote:
> Re-adding LKML.
>
> On Fri, Dec 04, 2009 at 11:39:25PM +0200, Lior Dotan wrote:
>   
>> On Fri, Dec 4, 2009 at 10:24 PM, Andy Isaacson <adi@hexapodia.org> wrote:
>>     
>>> For what it's worth, I'm testing suspend-to-ram on Ubuntu 9.10 x86_64
>>> with 2.6.32 final on a T500 and it's been pretty reliable -- I've
>>> suspended by closing the lid at least a dozen times and it hasn't locked
>>> up yet.
>>>       
>> I'm using either KDE menu to suspend or hibernate-ram from hibernate-script.
>> I will try to use the lid and see if it makes any difference.
>> The strange thing is that I tried using rc6 & rc7 and they don't work now
>> even though they used to, so I now I need to see what broke it.
>>     
>
> I mentioned the lid because of BZ #14484 which is only on Intel GMA plus
> using the lid switch to trigger suspend.  Since neither is relevant to
> you it's just a red herring. :)
>
>   
>>> 1. are you using DMAR (VT-d)?  I'm not, and I had problems on another
>>>   machine (also Core 2 Duo with GM45 graphics) when I tried suspending
>>>   with CONFIG_DMAR=y.
>>>       
>>  I disabled DMAR but still no luck.
>>     
>
> It's getting better but DMAR has still been a little problematic for me
> the last few months.  Updating to the very latest BIOS does help
> sometimes.
>
>   
>>> 2. are you running into http://bugzilla.kernel.org/show_bug.cgi?id=14484
>>>   or a similar problem?
>>> 3. (if you have GMA graphics) Are you up to date on the xorg-video-intel
>>>   driver?  I'm using KMS and xorg-video-intel 2.9.0.  2.8.x is missing
>>>   some relevant bugfixes.  (Of course if you have ATI graphics then
>>>   this isn't relevant.)
>>>
>>>       
>> I'm using the Radeon GPU so no KMS for me yet.
>>     
>
> Sounds like your Radeon or fglrx driver got updated and broke
> suspend/resume.
>   
I got some progess, when using the Intel GMA, the suspend works fine. 
The problem are only when using the radeon driver.
I am trying to use KMS for radeon but it fails to load the firmware and 
the system boots without KMS. I will disable KMS and revert the 
xf86-video-ati driver to the latest released version (I am now using the 
git version).

> -andy
>   
Thanks for your help,
Lior.
