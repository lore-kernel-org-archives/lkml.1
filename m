Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbXFWJ22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbXFWJ22 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 05:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbXFWJ2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 05:28:20 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:17001 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbXFWJ2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 05:28:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oVuKWC8IHej0qsw26d84tir3OdTA1pQfnhYV7afxXTAXCaYsyx85OIAefDW056p+cVUqcLNT52tHQeRont6k1MQK7h3PRr4XyzoOnIAH4ar9naVYL+S/sARg9xBiDrFjBK/4kp6K01Q8AybOz3tWZQInUDbbeTXTN44KK6kp7UM=
Message-ID: <9c4865a10706230228y503c7757r82739c85d08ec86@mail.gmail.com>
Date: Sat, 23 Jun 2007 05:28:18 -0400
From: "Russell Harmon" <eatnumber1@gmail.com>
To: "Alberto Gonzalez" <info@gnebu.es>
Subject: Re: Question about fair schedulers
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200706231118.43408.info@gnebu.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706230007.15622.info@gnebu.es>
	 <200706231001.02497.info@gnebu.es> <20070623082320.GX943@1wt.eu>
	 <200706231118.43408.info@gnebu.es>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I think you're not considering normal users here. Believe it or not, 99% of
> desktop users in the world just click on a icon to watch a video. And they DO
> want watch them, not use them for monitoring purposes (whatever that means).
>
> I acknowledge it's impossible to be inside a user's mind to decide what it's
> more important to him/her, but let's agree that clearly a audio/video player
> should have by default a higher priority than an audio/video encoder, for the
> simple reason that one task requires a certain amount of CPU to do the job
> correctly, while the other one can do the job correctly regardless of how
> much CPU time you give it. They are different in nature. What I don't know is
> if knowing this should belong to the CPU scheduler or to the application
> itself. But the bottom line is that on a desktop, tasks should receive
> different -unfair- amounts of CPU time to work correctly. The "fair" concept
> still looks wrong to me.
>
> Nicing tasks might not be hard at all, but expecting normal users to do so is
> not realistic. Either the scheduler or the applications should make these
> decisions for them (us).
While I agree in principle that less work for the end user who wants
it to "just work" is good (if done correctly), I think this is more an
issue of where the scheduler is being put to work. In a desktop
environment, I'd agree that you would want the player > encoder, but
in say a video authoring machine, you would definatley want the
encoder > player. It seems to me that the best solution would be a
compile time option to configure the scheduler for the environment it
will be working in.
I do think however that the default in most cases should be "it just
works" with the option of turning on the more advanced features.
