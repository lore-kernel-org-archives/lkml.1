Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbYIOSvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbYIOSvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 14:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbYIOSvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 14:51:20 -0400
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:54271 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754696AbYIOSvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 14:51:18 -0400
Date: Mon, 15 Sep 2008 19:51:12 +0100 (BST)
From: Mark Fortescue <mark@mtfhpc.demon.co.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: David Miller <davem@davemloft.net>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       joy@entuzijast.net
Subject: Re: Allow 8250 to work on sparc.
In-Reply-To: <20080915172211.6751bb17@the-village.bc.nu>
Message-ID: <Pine.LNX.4.61.0809151934040.23817@mtfhpc.demon.co.uk>
References: <20080912.211854.102505246.davem@davemloft.net>
 <Pine.LNX.4.61.0809151507250.23201@mtfhpc.demon.co.uk>
 <20080915172211.6751bb17@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Mon, 15 Sep 2008, Alan Cox wrote:

>> At the user level, there is no difference between a sun zilog serial port,
>> an 8250 serial port or a USB serial port so these should be allocated
>> using the same allocation system.
>
> That isn't strictly true.

I am intrigued. Other than the valid baud rates what differences are 
visible at the user level?

>
>> For me, it would also simplify the issue of trying to work what devive to
>> look for when I plug in a new USB serial port device. It would be the new
>> /dev/ttyS<x> to appear in /dev.
>
> Naming is a private matter for udev anyway, independant of numbering for
> major/minor
>

Yes, but I have not found a simple way to configure it to add serial port 
devices to the next available /dev/ttyS<xx>. If this was the default, it 
would be much easier for me :). (I am assuming that all the different 
serial port devices I use are transparent at the user level, hence my 
question above.)

Regards
 	Mark.
