Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbXLHUd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbXLHUd1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbXLHUdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:33:20 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:3945 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbXLHUdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:33:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=E5djRWZKbUK4sCGfQliMXY7L8TBI8+CNXBRzC/49WsDX1Kg0fHrrkkiuduEMflI2MmQXgZ6iSfA1G0EmoSVTIK2APdSvhquKy0xkRWFNScDYQIGqkemV043hUHEA90tqHfF/WN1F0QR1cq7FwQaN4aJ5IiHCgY1dWQzFkVThORI=
Message-ID: <3efb10970712081233q10ac7f6bwb2c0ab8107714c1c@mail.gmail.com>
Date: Sat, 8 Dec 2007 21:33:02 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: lockdep problem conversion semaphore->mutex (dev->sem)
Cc: "Daniel Walker" <dwalker@mvista.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Dave Chinner" <dgc@sgi.com>
In-Reply-To: <1197144276.6353.44.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3efb10970712071502p4db9c58ck623c377172ead4b2@mail.gmail.com>
	 <1197116185.31440.1.camel@twins>
	 <1197132792.1568.162.camel@jnielson-xp.ddns.mvista.com>
	 <1197133910.6353.33.camel@lappy>
	 <1197133577.1568.166.camel@jnielson-xp.ddns.mvista.com>
	 <1197135413.6353.36.camel@lappy>
	 <3efb10970712081152o2d4abcfbo634a8d2445c09699@mail.gmail.com>
	 <1197144276.6353.44.camel@lappy>
X-Google-Sender-Auth: 33a9646dc7eb0219
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter,

> And while you might not see it in-tree anymore, lockdep does help out
> tremendously while developing new code. I'm sure that without it the
> locking would be in a much worse state than it is today.

I am not arguing that, I am also convinced it has done a good job.

> I have a good idea on how to annotate this, but not yet the time to do
> so.

Sounds good...

> Aside from the nesting problems, the dev->sem has other problems as
> well. Converting this is rather non-trivial.

Which problems? I did not see any special things, it looked rather
straight forward. What have I overlooked?

> I'd not put it as harshly as you put it though, lockdep makes some
> assumptions which can lead to false positives -

By putting it this black and white, it usually helps to get all the
opinions clear ;-)
(By staying in the middle, everybody usually tend to agree ;-)

> otoh these assumptions
> often end up pointing out 'curious' locking coupled to 'curious' data
> structures. And fixing up these things often leads to better and simpler
> code.
> The emphasis is on often, this is one of the cases where this is not so.
> So while it does restain the creativity of locking it often ends up
> being for the better.

Ack.

Kind Regards,

Remy
