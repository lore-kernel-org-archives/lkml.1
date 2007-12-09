Return-Path: <linux-kernel-owner+w=401wt.eu-S1751982AbXLIPkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbXLIPkN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 10:40:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbXLIPkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 10:40:00 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:29342 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbXLIPj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 10:39:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Njg3+yug9IlO8BuP5RuBa48ShfkMGPOwhK+NgCjxnJkJ1kW3tC0iT/WM/4u4mG8Zy7T3juaaoc8n2byZmFe6gQTKWjrMkdO0pV4U7JAWJOP01d8gApiZUeSGpP/ENwPCnA+3kiSW+uyFza1HfWyh4ZjRXidOqEBWJdh7TwVi7EQ=
Message-ID: <475C0C47.6090706@gmail.com>
Date: Mon, 10 Dec 2007 00:39:51 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
References: <200712080340.49546.rjw@sisk.pl>	<20071208015227.3a1c7fae.akpm@linux-foundation.org>	<475B9270.6070902@gmail.com>	<20071209134217.7ff02dd2@the-village.bc.nu>	<475C0522.7080702@gmail.com> <20071209152509.5c6e33a2@the-village.bc.nu>
In-Reply-To: <20071209152509.5c6e33a2@the-village.bc.nu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Newly broken ones will be regressions.  How many do we fix by the
>> change?  On SATA, setting the correct transfer chunk size doesn't seem
>> to fix many.
> 
> Regressions are not some kind of grand evil. Better to regress the odd
> device than continue to break entire controllers.

We need to put more weight on regressions as it at least makes releases
predictable to users.  Anyways, I wasn't saying it was some absolute
maxim.  I was literally asking how many so that we can evaluate the
trade off.

>>> Tejun - instead of backing out important updates for 2.6.24 we should
>>> just blacklist that specific drive for now and sort it nicely in 2.6.25,
>>> not revert stuff and break everyone elses ATAPI devices.
>> We'll need to blacklist setting transfer chunk size, eek, and let's
>> leave that as the last resort and hope that we find the solution soon.
>> Blacklist takes time to develop and temporary blacklist for just one
>> release doesn't sound like a good idea.
> 
> It seems to be sensible to me *if* it is just this one device we are
> somehow confusing and that one device is holding up fixing everything
> else.

Yeah, if it's this one device, I fully agree.  Let's see how debugging
turns out.

-- 
tejun
