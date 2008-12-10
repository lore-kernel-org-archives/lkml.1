Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbYLJEfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbYLJEfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 23:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbYLJEfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 23:35:23 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:58329 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbYLJEfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 23:35:22 -0500
Date: Tue, 9 Dec 2008 20:33:47 -0800 (PST)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Richard Purdie <rpurdie@rpsys.net>
cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH 4/4] leds: Let GPIO LEDs keep their current state
In-Reply-To: <1228298664.9126.3.camel@ted>
Message-ID: <Pine.LNX.4.64.0812092013030.28806@t2.domain.actdsltmp>
References: <Pine.LNX.4.64.0810241442240.3790@t2.domain.actdsltmp> 
 <1224889741-4167-4-git-send-email-tpiepho@freescale.com>  <1226933427.17109.15.camel@ted>
  <Pine.LNX.4.64.0811201640570.11673@t2.domain.actdsltmp>  <20081123123154.GB7310@ucw.cz>
 <1228298664.9126.3.camel@ted>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2008, Richard Purdie wrote:
> On Sun, 2008-11-23 at 13:31 +0100, Pavel Machek wrote:
>> On Thu 2008-11-20 17:05:56, Trent Piepho wrote:
>>> I thought of that, but it ends up being more complex.  Instead of just
>>> using:
>>> static const struct gpio_led myled = {
>>>  	.name = "something",
>>>  	.keep_state = 1,
>>> }
>>>
>>> You'd do something like this:
>>>  	.default_state = LEDS_GPIO_DEFSTATE_KEEP,
>>>
>>> Is that better?
>>
>> Yes.
>
> Yes, agreed, much better.

Oh very well, I'll change it.  But I reserve the right to make a sarcastic
commit message.
