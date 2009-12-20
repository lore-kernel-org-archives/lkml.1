Return-Path: <linux-kernel-owner+w=401wt.eu-S1754408AbZLTXuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbZLTXuR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 18:50:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbZLTXuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 18:50:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbZLTXuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 18:50:13 -0500
Message-ID: <4B2EB7E1.7090506@redhat.com>
Date: Mon, 21 Dec 2009 09:48:49 +1000
From: Peter Hutterer <peter.hutterer@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Korsgaard <jacmet@sunsite.dk>
CC: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: add multi-input quirk for NextWindow Touchscreen.
References: <20091203050810.GA26595@barra.bne.redhat.com>	<87zl60s17o.fsf@macbook.be.48ers.dk> <4B1836A6.405@redhat.com>	<871vjasxnm.fsf@macbook.be.48ers.dk> <4B190D88.4090102@redhat.com>	<87ws12rh5j.fsf@macbook.be.48ers.dk> <4B1C96C4.5080709@redhat.com>	<87hbs0mqju.fsf@macbook.be.48ers.dk> <4B2B0CCE.2020406@redhat.com> <87638239ha.fsf@macbook.be.48ers.dk>
In-Reply-To: <87638239ha.fsf@macbook.be.48ers.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/12/09 08:05, Peter Korsgaard wrote:
>>>>>> "Peter" == Peter Hutterer<peter.hutterer@redhat.com>  writes:
>
> Hi,
>
>   >>  I see this:  http://peter.korsgaard.com/nw.png
>
>   Peter>  argh. now you made me use vista! ;)
>
> Sorry, I promise it won't happen again ;)
>
>   Peter>  For reporting mode 4 and 3, the events are Z/Rx + touch
>   Peter>  For reporting mode 1 and 9, the events are ABS_X/Y and left button
>   Peter>  For reporting mode 0 and 8, no events are sent (unsurprisingly)
>
>   Peter>  So it seems the only difference between our two models is the default
>   Peter>  reporting mode - assuming that 4 is the default, we've had this thing
>   Peter>  for a year without doing much with it but it could well be that
>   Peter>  someone set it earlier or one of the HP Touchsmart software pieces
>   Peter>  changed it.
>
> Ok, thanks for checking it all out! Just to be completely sure, the
> quirk doesn't cause any problems in mode 1/9, right?

no, the evtest output looks the same with and without the quirk, 
including right button emulation on long press, etc.

Cheers,
   Peter

