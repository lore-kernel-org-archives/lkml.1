Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122AbZK1WSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbZK1WSa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 17:18:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbZK1WS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 17:18:29 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:56801 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbZK1WS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 17:18:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=oXsMzqCdp3uoaQUSfqaXt+bQ9dYKpA0aoGYvfudx5+d7ucq5ebJyLWRLt4qOILYdhr
         PSINZfECUPns95aNyWtYOKaZjHNgebCqrjSXSFHflG9YpDY5SgxthNoQQxrzyzhoGnbm
         PeFbyxyOdkVw1VaoqUbY7GGGm8KwXd3S4y7Vk=
MIME-Version: 1.0
In-Reply-To: <9e4733910911281410i75bf19b7xa4dfd6ad1dc1b748@mail.gmail.com>
References: <m3r5riy7py.fsf@intrepid.localdomain>
	 <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>
	 <4B116954.5050706@s5r6.in-berlin.de>
	 <9e4733910911281058i1b28f33bh64c724a89dcb8cf5@mail.gmail.com>
	 <4B117DEA.3030400@s5r6.in-berlin.de>
	 <9e4733910911281208t23c938a2l7537e248e1eda4ae@mail.gmail.com>
	 <4B11881B.7000204@s5r6.in-berlin.de>
	 <9e4733910911281246r65670e1free76e98ff4a23822@mail.gmail.com>
	 <4B119A36.8020903@s5r6.in-berlin.de>
	 <9e4733910911281410i75bf19b7xa4dfd6ad1dc1b748@mail.gmail.com>
Date: Sat, 28 Nov 2009 17:18:34 -0500
Message-ID: <9e4733910911281418s702489e5t418eab5623c2af98@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR 
	system?
From: Jon Smirl <jonsmirl@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, khc@pm.waw.pl, awalls@radix.net,
       dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
       jarod@wilsonet.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       maximlevitsky@gmail.com, mchehab@redhat.com, superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm looking at a Sony multi-function remote right now. It has five
devices and forty keys. Each of the five devices can transmit 0-9,
power, volume, etc. It transmits 5*40 = 200 unique scancodes.

I want the five devices to correspond to five apps. What's the plan
for splitting those 200 scancodes into the five apps?

I did it by creating five evdev devices each mapping 40 scancodes.
That's lets me reuse KP_1 for each of the five apps.


-- 
Jon Smirl
jonsmirl@gmail.com
