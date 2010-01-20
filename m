Return-Path: <linux-kernel-owner+w=401wt.eu-S1752360Ab0ATSqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360Ab0ATSqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 13:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273Ab0ATSqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 13:46:19 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:62298 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab0ATSqS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 13:46:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TGmvVt7P/WwVOJyePuRwC9mYFzseMG1X7naYJMaOZP4AyS+UVX3oi1f+0xnfIc7uOz
         STekhRukHuX6kauQS7Ik0dstzvvYEQtnedqwoivyPUsNazgBOQQT6BQjVFgAhmx7QmYP
         UmIOoFHpy/Ha53nAQwf23AFxfLl/O5OOvWcXw=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1001191306180.1334-100000@iolanthe.rowland.org>
References: <alpine.LFD.2.00.1001191625420.29861@casper.infradead.org>
	 <Pine.LNX.4.44L0.1001191306180.1334-100000@iolanthe.rowland.org>
Date: Wed, 20 Jan 2010 10:46:17 -0800
Message-ID: <e7bd23c31001201046u32122182l5b49fa76e4591a81@mail.gmail.com>
Subject: Re: Font selection with i915
From: Corbin Simpson <mostawesomedude@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Simmons <jsimmons@infradead.org>, dri-devel@lists.sourceforge.net,
       Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI the legacy non-KMS path (nomodeset) is deprecated in kernel and
was recently dropped from the X driver. You should be able to use
fbset to change the resolution of your fbcon though.

~ C.

On Tue, Jan 19, 2010 at 10:09 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 19 Jan 2010, James Simmons wrote:
>
>>
>> > When Fedora 12 loads i915 during initramfs probing on my system, the
>> > driver automatically installs a tiny 160x64 font.  How can I prevent it
>> > from doing this, or tell it to use a larger 80x25 font instead?
>> >
>> > Is this documented anywhere?
>>
>> Not really. Here is how you enable larger fonts. Configure your kernel. Go
>> into the Graphics support menu. This the the menu that has the
>> DRI/Framebuffer and backlight options. You will see a "Console display
>> driver support" option. Select it and you will have a new menu. You will
>> see the option "Select compiled-in fonts". Enable that and select the font
>> you want. Most likely it will be the Sun 12x22 font. Build your kernel.
>>
>> Their might be one more setup to do. Some distros like to load a console
>> font at boot up. Depending on the distro if that is the case you will have
>> to disable it.
>
> It turns out that preventing the mode switch is easier.  Finding it
> took a certain amount of digging, but the "nomodeset" kernel parameter
> prevents the console from leaving normal VGA mode.  If only it were
> documented...
>
> Alan Stern
>
>
> ------------------------------------------------------------------------------
> Throughout its 18-year history, RSA Conference consistently attracts the
> world's best and brightest in the field, creating opportunities for Conference
> attendees to learn about information security's most important issues through
> interactions with peers, luminaries and emerging and established companies.
> http://p.sf.net/sfu/rsaconf-dev2dev
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
>



-- 
Only fools are easily impressed by what is only
barely beyond their reach. ~ Unknown

Corbin Simpson
<MostAwesomeDude@gmail.com>
