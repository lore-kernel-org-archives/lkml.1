Return-Path: <linux-kernel-owner+w=401wt.eu-S1755627AbXLBROl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627AbXLBROl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 12:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbXLBROb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 12:14:31 -0500
Received: from rtr.ca ([76.10.145.34]:3550 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbXLBROa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 12:14:30 -0500
Message-ID: <4752E7F5.1000805@rtr.ca>
Date: Sun, 02 Dec 2007 12:14:29 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
Cc: dmitry.torokhov@gmail.com, rubini@vision.unipv.it,
       linux-input@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>, jkosina@suse.cz,
       linux-usb@vger.kernel.org
Subject: Re: REGRESSION: 2.6.24:  false double-clicks from USB mouse
References: <4752DB8C.50608@rtr.ca>	<4752E432.10504@rtr.ca>	<4752E5AD.40905@rtr.ca> <20071202090755.342280f6@laptopd505.fenrus.org>
In-Reply-To: <20071202090755.342280f6@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Sun, 02 Dec 2007 12:04:45 -0500
> Mark Lord <lkml@rtr.ca> wrote:
> 
>> Mark Lord wrote:
>>> Mark Lord wrote:
>>>> I've only just recently tried running 2.6.24 on my main machine.
>>>> And it appears that I'll have to go back to 2.6.23,
>>>> because the USB mouse is not working correctly.
>>>>
>>>> Single-clicking on things with 2.6.24 very frequently gives a 
>>>> "double-click".
>>>> This does not happen with 2.6.23.8.
>>>>
>>>> I wonder what broke it?
>>>>
>>>> I've grabbed mousedev.c from 2.6.23 and inserted that in place
>>>> of the updated 2.6.24 source, but no change.  So it's not that
>>>> file.
>>> ...
>>>
>>> Mmm.. reverting the entire drivers/hid directory to that from 2.6.23
>>> seems to have fixed the problem, so we now know it's in there
>>> somewhere.
>>>
> 
> 
> just making sure.. this is while running an untainted kernel without
> something like vmware loaded, right?
..

Absolutely.

But thanks for reminding me.. I need to re-run vmware-config.pl now.
