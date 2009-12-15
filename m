Return-Path: <linux-kernel-owner+w=401wt.eu-S933220AbZLOUOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220AbZLOUOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 15:14:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761033AbZLOUOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 15:14:07 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:47720 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761022AbZLOUOE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 15:14:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tCxaIdgqLvUdFQ4n58BnxxFZUWSeXgL/XggUQuKivL7MPEgUw4fpXOHrvtrAYgM+ew
         b1a3/E9muwaKzIFt+UWX6wdFq+tL2AsMbrQVVe2jl8Cg/ivXRJnnBVp9xLfV8DhlU3dJ
         XXP8RgLYh2n9wcF2rBHrho8fcBsYpyizOsFF8=
MIME-Version: 1.0
In-Reply-To: <20091215195859.GI24406@elf.ucw.cz>
References: <1260070593.3236.6.camel@pc07.localdom.local>
	 <4B1B99A5.2080903@redhat.com> <m3638k6lju.fsf@intrepid.localdomain>
	 <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>
	 <m3skbn6dv1.fsf@intrepid.localdomain>
	 <20091207184153.GD998@core.coreip.homeip.net>
	 <4B24DABA.9040007@redhat.com> <20091215115011.GB1385@ucw.cz>
	 <4B279017.3080303@redhat.com> <20091215195859.GI24406@elf.ucw.cz>
Date: Tue, 15 Dec 2009 15:14:02 -0500
Message-ID: <9e4733910912151214n68161fc7tca0ffbf34c2c4e4@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR 
	system?
From: Jon Smirl <jonsmirl@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net, j@jannau.net,
       jarod@redhat.com, jarod@wilsonet.com, kraxel@redhat.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 2:58 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>>       (11) if none is against renaming IR as RC, I'll do it on a next patch;
>
> Call it irc -- infrared remote control. Bluetooth remote controls will
> have very different characteristics.

How are they different after the scancode is extracted from the
network packet? The scancode still needs to be passed to the input
system, go through a keymap, and end up on an evdev device.

I would expect the code for extracting the scancode to live in the
networking stack, but after it is recovered the networking code would
use the same API as IR to submit it to input.

-- 
Jon Smirl
jonsmirl@gmail.com
