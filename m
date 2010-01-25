Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032Ab0AYWtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab0AYWtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 17:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641Ab0AYWtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 17:49:23 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:34110 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab0AYWtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 17:49:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=x8Jle0rraxeP2LftkBVmUrUAe7kMQgdOFUPC0hPByw3WoyfxdsI83AV1nrhX9e/ueu
         uFHyspWAIN/xIBzFF6cOkdTDl3L3PPXxuo8ld66DBSyEDkhbltrnEvzfE1KasNOwmB73
         BrgysubSY7WsOqzveg7Ff8mDqgLUDoe0muLJs=
MIME-Version: 1.0
In-Reply-To: <20100124093055.GA17607@core.coreip.homeip.net>
References: <3d8471ca1001231053k512011dcnfab50052ce3667fa@mail.gmail.com>
	 <20100124093055.GA17607@core.coreip.homeip.net>
Date: Mon, 25 Jan 2010 23:49:20 +0100
Message-ID: <3d8471ca1001251449g6bdbdb4fn11f566b41691f870@mail.gmail.com>
Subject: Re: evdev regression on macbook with 2.6.33-rc5
From: Guillaume Chazarain <guichaz@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: ajax@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 24, 2010 at 10:30 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> DOes the same behavior happens when you try using 'evtest' utility while
> in console?

Hi Dmitry,

While struggling to make evtest show keyboard events, I discovered
that the problem is an incompatibility with mouseemu
(http://packages.ubuntu.com/karmic/mouseemu) as killing it makes the
keyboard work fine.

So, with mouseemu running, evtest won't print any event at all even if
I move the mouse, and when mouseemu is off everything works fine and
evtest prints the expected events.

> Also, do you have external USB keyboard by any chance and if
> you do does it exibit the same problem?

Yup, I get the exact same behaviour with an external USB keyboard and
mouseemu running: keystrokes being delivered only when I finally move
the mouse or the trackpad.

Cheers.

-- 
Guillaume
