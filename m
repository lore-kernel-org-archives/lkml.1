Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab0BSM5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 07:57:14 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:62989 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab0BSM5L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 07:57:11 -0500
Message-ID: <4B7E8AA4.40307@corscience.de>
Date: Fri, 19 Feb 2010 13:57:08 +0100
From: Thomas Weber <weber@corscience.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20100217)
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@nokia.com>
CC: ext Jaya Kumar <jayakumar.lkml@gmail.com>, Thomas Weber <swirl@gmx.li>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND][PATCHv2 4/4] OMAP: DSS2: Add Innolux 7" display for
 DEVKIT8000
References: <1265917278-22011-1-git-send-email-swirl@gmx.li>	 <45a44e481002112155u68c806beg9fe0a3a122d09d25@mail.gmail.com> <1265988343.2433.312.camel@tubuntu.research.nokia.com>
In-Reply-To: <1265988343.2433.312.camel@tubuntu.research.nokia.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V01U2FsdGVkX1+58R8uhdHInaOw4PewoccLvOo4bBRYNZcSGhd
 x8LNnooueC4foVzjx+RoZLPjjGQGObCuSEIJvtwvgTLHnqQMrp
 OIBST9qY+PTHdLzgRwHeA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomi Valkeinen wrote:
> On Fri, 2010-02-12 at 06:55 +0100, ext Jaya Kumar wrote:
>   
>> On Fri, Feb 12, 2010 at 3:41 AM, Thomas Weber <swirl@gmx.li> wrote:
>>     
>
> [snip]
>
>   
>>> +
>>> +static struct omap_video_timings innolux_at_timings = {
>>> +       .x_res          = 800,
>>> +       .y_res          = 480,
>>> +
>>> +       .pixel_clock    = 40000,
>>> +
>>> +       .hsw            = 48,
>>> +       .hfp            = 1,
>>> +       .hbp            = 1,
>>> +
>>> +       .vsw            = 3,
>>> +       .vfp            = 12,
>>> +       .vbp            = 25,
>>> +};
>>> +
>>> +static int innolux_at_panel_probe(struct omap_dss_device *dssdev)
>>> +{
>>> +       dssdev->panel.config = OMAP_DSS_LCD_TFT | OMAP_DSS_LCD_IVS |
>>> +               OMAP_DSS_LCD_IHS;
>>> +       dssdev->panel.acb = 0x28;
>>> +       dssdev->panel.timings = innolux_at_timings;
>>> +
>>> +       return 0;
>>> +}
>>> +
>>>       
>> Hi Thomas, Tomi,
>>
>> Just curious, does this patch imply that code like this needs to be
>> written for every single LCD type and resolution that can be connected
>> to omap2? Maybe there is a better way, like a common table of timings
>> and values that can be selected with a module option or even
>> autodetected.
>>     
>
> Yes, it is true that currently you need to write these for every LCD. I
> have been thinking this issue, and I think we can make a common driver. 
>
> However, it's not just selecting timings, as LCDs can have also other
> characteristics than just the video timings. For example, some may have
> power on/off line, some reset enable/disable, some need 50ms after
> reset, some 80ms after reset etc.
>
> But if we manage to get a sane set of those settings into the table, we
> could perhaps cover most of the "dummy" LCDs with it.
>
> This change doesn't probably need any changes to the DSS core, only for
> the panel driver. Any takers for this task? =) 
>
>  Tomi
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>   
Hello,

sorry but I am not able to take the task.
Make it sense to rework this patch or do you want first the changes to
the panel driver?

Thomas


