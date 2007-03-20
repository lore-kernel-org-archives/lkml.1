Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbXCTHCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbXCTHCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 03:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbXCTHCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 03:02:47 -0400
Received: from 42.mail-out.ovh.net ([213.251.189.42]:54776 "HELO
	42.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752821AbXCTHCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 03:02:46 -0400
Message-ID: <45FF86F6.7050200@boichat.ch>
Date: Tue, 20 Mar 2007 15:02:14 +0800
From: Nicolas Boichat <nicolas@boichat.ch>
User-Agent: Thunderbird 1.5.0.10 (X11/20070309)
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: linux-kernel@vger.kernel.org, mactel-linux-devel@lists.sourceforge.net
Subject: Re: [RFC][PATCH] Apple SMC driver (hardware monitoring and control)
References: <45F7C083.7090504@boichat.ch> <b6c5339f0703191443l5f8c5271pf43ea62e0c79a614@mail.gmail.com>
In-Reply-To: <b6c5339f0703191443l5f8c5271pf43ea62e0c79a614@mail.gmail.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Ovh-Remote: 137.132.204.228 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Bob Copeland wrote:
> On 3/14/07, Nicolas Boichat <nicolas@boichat.ch> wrote:
>> Hello,
>>
>> I developed, a while ago, a driver the Apple System Management
>> Controller, which provides an accelerometer (Apple Sudden Motion
>> Sensor), light sensors, temperature sensors, keyboard backlight control
>> and fan control on Intel-based Apple's computers (MacBook Pro, MacBook,
>> MacMini).
> 
> Hi Nicolas,
> 
> I tried out an earlier version of this patch several months ago just to
> play
> around with the joystick part of the accelerometer driver on my MacBook,
> and
> found that it was backwards in the y-direction compared to what Neverball
> seemed to want (of course, NB has no way to invert the joystick).  I think
> I just did something like this in my own copy:
> 
> +       y = -y;
>        input_report_abs(applesmc_idev, ABS_X, x - rest_x);
>        input_report_abs(applesmc_idev, ABS_Y, y - rest_y);
> 
> I don't claim you necessarily want to change it, but thought I'd pass it
> along.

I tried neverball on my Macbook Pro 1st generation (Core Duo, not Core 2
Duo), and the x axis in inverted, not the y axis.

Could you confirm which axis is inverted on your Macbook?

Also, have you tried the modified hdaps-gl, available here:
http://mactel-linux.svn.sourceforge.net/viewvc/mactel-linux/trunk/tools/hdaps-gl/
? Is it working correctly?

Thanks,

Best regards,

Nicolas
