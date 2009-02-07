Return-Path: <linux-kernel-owner+w=401wt.eu-S1755756AbZBHAAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbZBHAAI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 19:00:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbZBGX7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 18:59:55 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:40356 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbZBGX7y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 18:59:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WWcuvY2MLzxkgDZ7G5VX05iSYrozCPqNWVsKCvPnH0hf5oFrlJIaHoGb8BdtJrecI+
         loZcXIlQQqrfyq23laJkEmBBJHQYZ5VKdDhj00VzK809upL8itoNoYd1mI9cAMh5XaLN
         U/yUGvHok637KrvYNJg4LFvurbCzIBJV4hSVg=
MIME-Version: 1.0
In-Reply-To: <498D9F02.9000107@tremplin-utc.net>
References: <1233967681-6378-1-git-send-email-giuseppe.bilotta@gmail.com>
	 <498D9F02.9000107@tremplin-utc.net>
Date: Sun, 8 Feb 2009 00:59:52 +0100
Message-ID: <cb7bb73a0902071559w70b3367el9471db894872257f@mail.gmail.com>
Subject: Re: [PATCH] lis3lv02d: add axes knowledge of HP Pavilion dv5 models
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
To: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       Palatis Tseng <palatis@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 7, 2009 at 3:47 PM, Éric Piel <eric.piel@tremplin-utc.net> wrote:
> Giuseppe Bilotta schreef:
>> Add support for HP Pavlion dv5 models, whose sensor has an inverted x
>> axis.
>>
>> Signed-off-by: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
> Acked-by: Eric Piel <Eric.Piel@tremplin-utc.net>
>
> Looks good.
> Andrew, would you mind queuing it?
>> ---
>> My HP Pavilion dv5 has an inverted x axis of the accelerometer, so this
>> patch marks the inversion for all the dv5. I can include the full
>> dmidecode output if this is deemed necessary.
>>
>> With the laptop standing still on my desk jstest reports X and Y values
>> fluctuating from -8k to +8k (more or less). I assume this is normal?
> What does "k" stands for? If that's the unit of the joystick output:
> yes, that's perfectly normal, just some noise/vibration. If that's 1000,
> it's far too much to be normal.

k is for thousands. I thought it could have been normal because
someone (Pavel?) mentioned the disk park script trigged even if he was
just walking around, so I just assumed the sensor to be extremely
sensible. OTOH the maximum range of the sensor, as reported by jstest,
seems to be -32k to +32k, and 8k is about one forth of it. Considering
sometimes the fluctuations even peak to 12k, there might be something
else at play here. Any suggestions on helping debug the issue are
welcome.





-- 
Giuseppe "Oblomov" Bilotta
