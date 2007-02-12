Return-Path: <linux-kernel-owner+w=401wt.eu-S933067AbXBLHa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067AbXBLHa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933069AbXBLHa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:30:27 -0500
Received: from mail06.syd.optusnet.com.au ([211.29.132.187]:33023 "EHLO
	mail06.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933068AbXBLHaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:30:25 -0500
From: Con Kolivas <kernel@kolivas.org>
To: malc <av1474@comtv.ru>
Subject: Re: CPU load
Date: Mon, 12 Feb 2007 18:29:47 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <loom.20070212T063225-663@post.gmane.org> <200702121712.50168.kernel@kolivas.org> <Pine.LNX.4.64.0702121006030.1049@home.oyster.ru>
In-Reply-To: <Pine.LNX.4.64.0702121006030.1049@home.oyster.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702121829.47453.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 February 2007 18:10, malc wrote:
> On Mon, 12 Feb 2007, Con Kolivas wrote:
> > Lots of confusion comes from this, and often people think their pc
> > suddenly uses a lot less cpu when they change from 1000HZ to 100HZ and
> > use this as an argument/reason for changing to 100HZ when in fact the
> > massive _reported_ difference is simply worse accounting. Of course there
> > is more overhead going from 100 to 1000 but it doesn't suddenly make your
> > apps use 10 times more cpu.
>
> Yep. This, i belive, what made the mplayer developers incorrectly conclude
> that utilizing RTC suddenly made the code run slower, after all /proc/stat
> now claims that CPU load is higher, while in reality it stayed the same -
> it's the accuracy that has improved (somewhat)
>
> But back to the original question, does it look at what's running on timer
> interrupt only or any IRQ? (something which is more in line with my own
> observations)

During the timer interrupt only. However if you create any form of timer, they 
will of course have some periodicity relationship with the timer interrupt.

-- 
-ck
