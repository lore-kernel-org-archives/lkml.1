Return-Path: <linux-kernel-owner+w=401wt.eu-S1754231AbZBIJu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbZBIJu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 04:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZBIJuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 04:50:17 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:36768 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbZBIJuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 04:50:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lrL/BzQhW2+vly1Xgs6nu7zHFsa9/SGE4BReGgjQzejarTFphNUbvuXtWv+/eXQkQZ
         iiHr+80v/dadgqXjCWmE8b/ezmH457M6GKvMDXN5CUU5bYb7IE10IOh/iILyLTdfkC/O
         AdwRsG311LlOk8OAIWTVEa3z3cNmOI9lQ0WF4=
MIME-Version: 1.0
In-Reply-To: <20090209094416.GB4358@atrey.karlin.mff.cuni.cz>
References: <1233967681-6378-1-git-send-email-giuseppe.bilotta@gmail.com>
	 <20090209094416.GB4358@atrey.karlin.mff.cuni.cz>
Date: Mon, 9 Feb 2009 10:50:14 +0100
Message-ID: <cb7bb73a0902090150i23e50c94g2df9d27999612e35@mail.gmail.com>
Subject: Re: [PATCH] lis3lv02d: add axes knowledge of HP Pavilion dv5 models
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 9, 2009 at 10:44 AM, Pavel Machek <pavel@suse.cz> wrote:
>> Add support for HP Pavlion dv5 models, whose sensor has an inverted x
>> axis.
>>
>> Signed-off-by: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
>> ---
>> My HP Pavilion dv5 has an inverted x axis of the accelerometer, so this
>> patch marks the inversion for all the dv5. I can include the full
>> dmidecode output if this is deemed necessary.
>>
>> With the laptop standing still on my desk jstest reports X and Y values
>> fluctuating from -8k to +8k (more or less). I assume this is normal?
>
> Well, on hp2140 it fluctuates 1000+-500 or so... But Z axis is still
> significantly different.
>
> How much is 7 while in "steady state" for you?
>                                                                Pavel

Assuming 7 here means Z, the Z axis fluctuates in the + range. All
three axis seem to hold to 4k most of the time (+ or - for X and Y,
only + for Z), with not infrequent peaks of 8k (+ or - for X and Y,
only + for Z), and seldom peaks at around 12k. Z seems to peak to 12k
more often, I only rarely manage to see X or Y peaking so high.

-- 
Giuseppe "Oblomov" Bilotta
