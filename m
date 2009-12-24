Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbZLXNrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbZLXNrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 08:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbZLXNrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 08:47:08 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:35960 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbZLXNrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 08:47:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Z+B9FyItt3pnPs3NVtaOZl0CsPDferI56ha1xLkCM9CZ0pRr9f9ZWaA3kqGJKJUzmm
         k0zhJGET1CanGHfCMUieltXmJmmhwC/nxJGAD2Q+Sf98CaPIJI/SB1+BMtqQVlQi5x3n
         s3czqn/YjPbWWEzTAPg1uDh/vLUBMXBaor0RU=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.0912240356070.3483@bogon.housecafe.de>
References: <f19d625d0912240309g5c066de7pc4dc9d95c084d4df@mail.gmail.com>
	 <alpine.DEB.2.01.0912240356070.3483@bogon.housecafe.de>
Date: Thu, 24 Dec 2009 16:47:06 +0300
Message-ID: <f19d625d0912240547q2a82a82fueaef72c425c02279@mail.gmail.com>
Subject: Re: 2.6.28.10 - kernel BUG at mm/rmap.c:725
From: CoolCold <coolthecold@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 24, 2009 at 3:01 PM, Christian Kujau <lists@nerdbynature.de> wrote:
> On Thu, 24 Dec 2009 at 14:09, CoolCold wrote:
>> 3 days ago LA on server become very high
>
> Was the higher load caused by "real" work, i.e. were there more processes
> running than usual or did the load increase "just so"?
Programmer was editing some scripts and reported he had messages in
console (actually the same messages as in the log), server was unable
to do usual work - LA becomes too high, so it was rebooted ( not
resetted ). After reboot server continued to work fine. Now I'm
figuring out what happened.

>
>> bug - kernel BUG at mm/rmap.c:725! . Googling didn't provide me with
>> exact answer is it bug or hardware problems, something similar was
>
> Did you check for hardware problems? Running memtest for a day would be a
> good start, I think. If the load did increase "just so" and the machine
> (and the same kernel) were stable before, it's most likely hardware
> related.
Machine was not rock solid - got occasional hangs once or two a month,
but without any records in logs and as there is no IPKVM, so i can't
say were something like kernel panic on console or not. Rephrasing
question - is this 'Kernel BUG' looking like bug or more than hardware
problem.
Memtest was not done yet though is planned when other machine will be rented.

>
> Christian.
> --
> BOFH excuse #102:
>
> Power company testing new voltage spike (creation) equipment
>



-- 
Best regards,
[COOLCOLD-RIPN]
