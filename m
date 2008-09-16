Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbYIPNQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbYIPNQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 09:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbYIPNPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 09:15:48 -0400
Received: from anchor-post-31.mail.demon.net ([194.217.242.89]:3543 "EHLO
	anchor-post-31.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751561AbYIPNPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 09:15:47 -0400
Date: Tue, 16 Sep 2008 14:15:43 +0100 (BST)
From: Mark Fortescue <mark@mtfhpc.demon.co.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: David Miller <davem@davemloft.net>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       joy@entuzijast.net
Subject: Re: Allow 8250 to work on sparc.
In-Reply-To: <20080916115400.31522d77@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.61.0809161343450.25955@mtfhpc.demon.co.uk>
References: <20080912.211854.102505246.davem@davemloft.net>
 <Pine.LNX.4.61.0809151507250.23201@mtfhpc.demon.co.uk>
 <20080915172211.6751bb17@the-village.bc.nu> <Pine.LNX.4.61.0809151934040.23817@mtfhpc.demon.co.uk>
 <20080916115400.31522d77@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Tue, 16 Sep 2008, Alan Cox wrote:

>> I am intrigued. Other than the valid baud rates what differences are
>> visible at the user level?
>
> There are lots of variations between hardware of all kinds but the big
> one with USB devices is generally latency.
>

At the driver level there are lots of varients but I was under the 
impression that at the user level, the interface is common for async 
serial ports.

Latency can be an issue, but can it be read/changed via the user <-> 
kernel interface in a way that is not common to all async serial ports?

If not, it is transparent at the programming interface for user level code 
so the USB serial ports are no different at this level to classic PC AT 
serial ports and as such I see no reason why, in the long run, they should 
not share minor number space.

Taking the argument to its logical conclusion, all devices that have a 
common user <-> kernel interface should have device drivers that are 
capable of sharing minor device number space.

I am sure this discusion will crop up again in the future :).

Regards
 	Mark.
