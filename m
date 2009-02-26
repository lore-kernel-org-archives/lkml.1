Return-Path: <linux-kernel-owner+w=401wt.eu-S1758847AbZBZVTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847AbZBZVTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 16:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZBZVT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 16:19:26 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:53039 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758029AbZBZVTZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 16:19:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Db2kd87n7uMfLGTbina75U0LEmtqXYrx6l9fgXGXCTNIJZbPTsdkmBP0AZNcX+sVim
         pjZsaM/42zT13lnQFUiQkQwvUWPrmXuuoSZ9hnB3+mh6/2MNt2kZ6o0VJQVpZRhII06T
         EkmP2TGh64ynhchjlJwbifq6Mn6ctB8Wok67s=
MIME-Version: 1.0
In-Reply-To: <49A6FEE2.90700@krogh.cc>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>
	 <49A6F39F.9040801@krogh.cc>
	 <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>
	 <49A6FEE2.90700@krogh.cc>
Date: Thu, 26 Feb 2009 13:19:22 -0800
X-Google-Sender-Auth: 3e60d76ef0f64aa2
Message-ID: <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>
Subject: Re: Linux 2.6.29-rc6
From: john stultz <johnstul@us.ibm.com>
To: Jesper Krogh <jesper@krogh.cc>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 12:43 PM, Jesper Krogh <jesper@krogh.cc> wrote:
> Linus Torvalds wrote:
>>
>> On Thu, 26 Feb 2009, Jesper Krogh wrote:
>>>
>>> 2.6.26.8 doesnt have this problem.
>>>
>>> The "current_clocsource" is the same on both systems.
>>>
>>> $ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
>>> tsc
>>
>> What does the frequency calibrate to? It should be in the dmesg. Does it
>> differ by a big amount?
>
> Non-working:
> $ dmesg | grep -i freq
> [    0.004007] Calibrating delay loop (skipped), value calculated using
> timer frequency.. 4620.05 BogoMIPS (lpj=9240104)
>
> 2.6.26.8 doesn't have that information.

I'm surprised the clocksource watchdog isn't catching it.

What's the output from:
cat /sys/devices/system/clocksource/clocksource0/available_clocksource

Also mind sending the full dmesg for both kernels?

thanks
-john
