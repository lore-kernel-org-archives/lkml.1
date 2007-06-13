Return-Path: <linux-kernel-owner+w=401wt.eu-S1758678AbXFMOJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbXFMOJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 10:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756896AbXFMOJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 10:09:36 -0400
Received: from neon.samage.net ([85.17.153.66]:32878 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756846AbXFMOJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 10:09:35 -0400
Message-ID: <41219.81.207.0.53.1181743761.squirrel@secure.samage.net>
In-Reply-To: <20070613081825.GF13747@elf.ucw.cz>
References: <20070604112426.GA2707@elf.ucw.cz>
    <d120d5000706041046j1da16c6el350d9da1d74d508b@mail.gmail.com>
    <20070604205701.GD2711@elf.ucw.cz>
    <200706120142.13173.dtor@insightbb.com>
    <52481.81.207.0.53.1181691356.squirrel@secure.samage.net>
    <20070613081825.GF13747@elf.ucw.cz>
Date: Wed, 13 Jun 2007 16:09:21 +0200 (CEST)
Subject: Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?
From: "Indan Zupancic" <indan@nul.nu>
To: "Pavel Machek" <pavel@ucw.cz>
Cc: "Dmitry Torokhov" <dtor@insightbb.com>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Andi Kleen" <ak@suse.de>, "Jiri Kosina" <jikos@jikos.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 4052b6d1c9976086d5ab5ce040fcf5b8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, June 13, 2007 10:18, Pavel Machek wrote:
>> Well, as I said before, I've the "stuck key"/repeated output too (as well
>> as a warping PS/2 mouse), but no blinking led problem, so I believe the
>> two things are totally unrelated.
>
> Well, after turning off CONFIG_BLINK, my problems went away, and with
> a fast-blink done from userspace, I can make them way worse. They
> _are_ related here.

I missed you saying that before, so to me it looked like everyone just
assumed that.

So, just for fun, I tried running:

while true; do setleds +num; setleds -num; done

and it totally locked up my keyboard. Even SysRq didn't work. On the
bright side, the numlock LED was indeed blinking. Though running the
same with a sleep 0.1 added doesn't produce any problems. So maybe
my problem is indeed a bit related to this after all, somehow. Anyone
any ideas how to debug this problem?

Greetings,

Indan


