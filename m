Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbZCLBJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbZCLBJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 21:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbZCLBJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 21:09:14 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:46372 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbZCLBJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 21:09:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AV/dzW7vZ8at09PcjFv2x9Aq9chWyS8pGSfsYeDvtMKRqXVyj3YlD9OJmaDr6ElzOP
         UiqpL6XuQtrcWffOnEi4LgZrXIOC1yX/l3kcrRa1x4R0mZMUKth6LWnG/Oq36WWMmwt4
         zXp5PlUNjW8MH3Vmh1vXcUGmJHfXMTzvT3rzI=
Message-ID: <49B860A5.7020805@gmail.com>
Date: Thu, 12 Mar 2009 02:08:53 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] Add virtual "idle" device
References: <1236033772-20329-2-git-send-email-marcin.slusarz@gmail.com> <20090306184356.GA1311@ucw.cz>
In-Reply-To: <20090306184356.GA1311@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Mon 2009-03-02 23:42:52, Marcin Slusarz wrote:
>> This virtual device can be used to tell user space about periods of time
>> when user didn't "touch" input devices (keyboards, mice, touchpads, joysticks,
>> etc). For now it supports only keyboard events.
>>
>> Notification is done through simple select/poll + ioctl interface.
>>
>> It can be used to implement screen savers, automatic suspend,
>> autoaway/autodisconnect (e.g. in instant messangers) without
>> any help from X server and its overhead (context switches).
> 
> I don't think this is good interface; what if you have more than one
> seat?

Good point. I haven't thought about it.
Moreover it wouldn't work with remote X sessions...

It could be used on single user systems (like laptops, personal desktops,
embedded), but user space couldn't know whether it safe to use it (maybe
excluding embedded).

> And without mouse handling it is useless anyway, so....

Well, I didn't want to dig too much into input layer just to
discover after patch submission that my core functionality is broken :).

Marcin

