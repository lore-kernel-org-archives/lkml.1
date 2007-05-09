Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbXEINpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbXEINpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 09:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756836AbXEINpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 09:45:21 -0400
Received: from p2020-adsah02tachib-acca.tokyo.ocn.ne.jp ([219.161.11.20]:61874
	"EHLO eggplant.ddo.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbXEINpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 09:45:19 -0400
Message-ID: <2329.192.168.1.10.1178718316.squirrel@eggplant.ddo.jp>
In-Reply-To: <1178712861.6291.5.camel@localhost.localdomain>
References: <1743.192.168.1.10.1178627225.squirrel@eggplant.ddo.jp><1178628407.6061.24.camel@localhost.localdomain><1638.192.168.1.10.1178710979.squirrel@eggplant.ddo.jp>
    <1178712861.6291.5.camel@localhost.localdomain>
Date: Wed, 9 May 2007 22:45:16 +0900 (JST)
Subject: Re: [PATCH 2/2] leds:arch/sh/boards/landisk LEDs supports
From: "kogiidena" <kogiidena@eggplant.ddo.jp>
To: "Richard Purdie" <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org
Reply-To: kogiidena@eggplant.ddo.jp
User-Agent: SquirrelMail/1.4.5
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2007-05-09 at 20:42 +0900, kogiidena wrote:
>> >As far as I can tell, the existing timer trigger can do everything the
>> >blink trigger can (and more besides).
>> I want to blink LED in the initial state.
>
> Are you after to set that per LED or would some standard configurable
> default for all LEDs work?
I'm sorry.The meaning of the question cannot be understood.
My LED is use in the following.
I want to blink LED while booting it.
When boot ends, LED is turned on.

> The approach is probably a good idea but you'll have to split struct
> timer_list timer from the data structure.
>
> Also, if default_trigger wasn't the timer trigger you have a nice oops
> waiting to happen.
I'm sorry that it is not possible to understand enough.
Please teach concretely.

I think that I become more convenient if the argument can be given to "default_trigger" for "all trigger".

kogiidena
-------------------------------
 Use example -- part of leds-landisk.c
-------------------------------
static struct timer_trig_data default_timer_trig_data = {
        .delay_on  = 250,
        .delay_off = 250,
};

static struct led_classdev landisk_leds[] = {
        [0] = {
                        .name = "power",
                        .brightness_set = landisk_led_set,
                        .default_trigger = "timer",
                        .default_trigger_data = &default_timer_trig_data,
               },
        [1] = {
                        .name = "status",
                        .brightness_set = landisk_led_set,
                        .default_trigger = "timer",
                        .default_trigger_data = &default_timer_trig_data,
               },
        [2] = {

