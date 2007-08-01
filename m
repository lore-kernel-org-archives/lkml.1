Return-Path: <linux-kernel-owner+w=401wt.eu-S1764442AbXHAN2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764442AbXHAN2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 09:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762270AbXHAN2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 09:28:43 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:60190 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761201AbXHAN2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 09:28:43 -0400
Message-ID: <46B089EA.4080600@gmail.com>
Date: Wed, 01 Aug 2007 15:26:02 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
CC: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       CK Mailinglist <ck@vds.kolivas.org>, teresa@kvitka.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux Kernel cfs scheduler and xorg kbd
References: <1185827130.26459.16.camel@xtower.fri>    <6bffcb0e0707301549t6be3cd97y27726f5421bb7680@mail.gmail.com>    <20070801064816.GC10134@elte.hu> <p73abtbpk2s.fsf@bingen.suse.de>    <46B06815.10200@gmail.com>    <46470.81.207.0.53.1185971693.squirrel@secure.samage.net>    <46B0818F.10204@gmail.com> <49653.81.207.0.53.1185973640.squirrel@secure.samage.net>
In-Reply-To: <49653.81.207.0.53.1185973640.squirrel@secure.samage.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2007 03:07 PM, Indan Zupancic wrote:

> On Wed, August 1, 2007 14:50, Rene Herman wrote:

>> On 08/01/2007 02:34 PM, Indan Zupancic wrote:
>>
>>> On Wed, August 1, 2007 13:01, Rene Herman wrote:
>>>> Teresa was already using 2.6.22.1, with CFS (v19.1) patched in, so reverting
>>>> that would be a matter of patching it out again. She said she wasn't seeing
>>>> trouble on other kernels though.
>>>>
>>>> I was the one who also saw keyboard trouble on 2.6.22.1 without CFS by the
>>>> way -- and haven't (yet) seen any anymore since patching _in_ CFS v19.1...
>>> Could the people who had or have keyboard problems try out Dmitry's
>>> input locking patches, and see if those help: http://lkml.org/lkml/2007/7/24/17
>>> And if it does, report it to him, either there or here after CCing him.
>> I'm having trouble reproducing this at will -- it sounded as though Teresa
>> had less trouble at least originally. Teresa?
> 
> Same here, so testing is a pain. I was more thinking about running a patched
> version for a day or longer and see if it happened or not. For me it happened
> irregularly, but definitely a few times a day.
> 
> (It might help if people report what they're using. So, for what it's worth, I'm
> using a PS/2 keyboard with xorg 1.2.0 with the "keyboard" driver.)

PS/2 keyboard, X.org 1.3.0 (version is at the top of /var/log/Xorg.0.log, or 
wherever your distribution puts that log), and this xkb config (in 
/etc/X11/xorg.conf):

Section "InputDevice"
         Identifier      "Keyboard0"
         Driver          "kbd"
         Option          "XkbModel"      "pc104"
         Option          "XkbLayout"     "us"
         Option          "XkbVariant"    "euro"
         Option          "XkbOptions"    "compose:rctrl"
EndSection

(you can forget that XkbVariant -- it's not yet in most distributions).

Problem as observed here consists of a sporadically stuck delete key in 
Thunderbird 2.0.0.5, using kernel 2.6.22.1 vanilla -- not yet observed using 
2.6.22.1-cfs-v19.1

Rene.

