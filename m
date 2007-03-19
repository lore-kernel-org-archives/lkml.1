Return-Path: <linux-kernel-owner+w=401wt.eu-S1030669AbXCSVpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030669AbXCSVpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030666AbXCSVnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:43:50 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:20693 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030660AbXCSVnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:43:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=um0BAQBg4+Y5BkhdMgECLFG6PCz4igWu4e72Zr7PcPWvai9yGwBPxGfLcBxVqmdySTbtvghTTYyhPROMZlLRIbD4UKsgMVE7zHLUqgHEl3Q/NGQvOJVHm9kwqLrUlLFXOTMLdEmTVLsO7bBap0x0PoN1uAUW/uCHuqKwfksNQqk=
Message-ID: <b6c5339f0703191443l5f8c5271pf43ea62e0c79a614@mail.gmail.com>
Date: Mon, 19 Mar 2007 17:43:38 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Nicolas Boichat" <nicolas@boichat.ch>
Subject: Re: [RFC][PATCH] Apple SMC driver (hardware monitoring and control)
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org, rlove@rlove.org,
       linux-kernel@hansmi.ch
In-Reply-To: <45F7C083.7090504@boichat.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45F7C083.7090504@boichat.ch>
X-Google-Sender-Auth: 86e0d7b24e1a5fc7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/14/07, Nicolas Boichat <nicolas@boichat.ch> wrote:
> Hello,
>
> I developed, a while ago, a driver the Apple System Management
> Controller, which provides an accelerometer (Apple Sudden Motion
> Sensor), light sensors, temperature sensors, keyboard backlight control
> and fan control on Intel-based Apple's computers (MacBook Pro, MacBook,
> MacMini).

Hi Nicolas,

I tried out an earlier version of this patch several months ago just to play
around with the joystick part of the accelerometer driver on my MacBook, and
found that it was backwards in the y-direction compared to what Neverball
seemed to want (of course, NB has no way to invert the joystick).  I think
I just did something like this in my own copy:

+       y = -y;
        input_report_abs(applesmc_idev, ABS_X, x - rest_x);
        input_report_abs(applesmc_idev, ABS_Y, y - rest_y);

I don't claim you necessarily want to change it, but thought I'd pass it
along.

Bob
