Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697AbYIXHFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbYIXHFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 03:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbYIXHE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 03:04:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:49868 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbYIXHE5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 03:04:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=W8ez6s4WSe0j4MS18Jb6pC6dKWNP3IOIO69n5d6Thx6DMJ/TQrhhMVq9txdVidxaGC
         9rNHDRI0QHB6Cmrv267LRYJBruBMQCvQsGCgmEYVpjy1bB13mkohdyBGD7MEXlYFotmb
         YAvAWT4OJQIEZY+x4gDf1Ov9qmrNhXUehXRq0=
Message-ID: <ed7dcf450809240004r1d3c7b3ds619cd7441ae0365e@mail.gmail.com>
Date: Wed, 24 Sep 2008 09:04:55 +0200
From: "=?ISO-8859-1?Q?S=F8ren_Hauberg?=" <hauberg@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: [PATCH] usbtouchscreen, 2.6.25
Cc: "Ondrej Zary" <linux@rainbow-software.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
In-Reply-To: <200809231613.41905.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <ed7dcf450809230142l62bb00aapb92e6cb225f0cbba@mail.gmail.com>
	 <200809231051.14016.linux@rainbow-software.org>
	 <ed7dcf450809230236v762e0aa3v8748c76a64121f0c@mail.gmail.com>
	 <200809231613.41905.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/23 Oliver Neukum <oliver@neukum.org>:
> Am Dienstag 23 September 2008 11:36:06 schrieb Søren Hauberg:
>> 2008/9/23 Ondrej Zary <linux@rainbow-software.org>:
>> > Calibration is a per-device thing. You can have more than one touchscreen (the
>> > swap_xy feature is also wrong, but better than nothing).
>>
>> Yes, this is true. I'm going to claim (and I have no factual evidence
>> to back this claim, I'm just making it up) that almost all touchscreen
>> users only have one touchscreen. So, I'd rather have something that
>> works for most users, then the current situation. Is it optimal? No!
>> Is it practical? I believe so. Using your words, it's "better than
>> nothing".
>
> But is it better than the X driver?

Obviously that depends on how you define "better" :-) The problem I'm
facing is that with the X driver there is no way to change calibration
without restarting X several times, which isn't acceptable for the
application we're developing. Sure, I could fix the X driver to allow
run-time changes to the calibration parameters, but that's a very
large task. On the other hand, solving the problem in the kernel was
dead-easy. So, I agree that solving the problem in-kernel might not be
the best possible solution, it's just the only one I actually have the
time to implement (and it'll work for most users).

> How do other touchscreens do it?

They seem to do nothing, i.e. let the problem be solved in user space.

Søren
