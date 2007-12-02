Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbXLBSUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbXLBSUk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 13:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbXLBSUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 13:20:31 -0500
Received: from rtr.ca ([76.10.145.34]:3569 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbXLBSUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 13:20:30 -0500
Message-ID: <4752F76D.8060600@rtr.ca>
Date: Sun, 02 Dec 2007 13:20:29 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, rubini@vision.unipv.it,
       linux-input@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: 2.6.24:  false double-clicks from USB mouse
References: <4752DB8C.50608@rtr.ca> <4752E432.10504@rtr.ca> <Pine.LNX.4.64.0712021903460.12208@twin.jikos.cz> <4752F6C7.4040904@rtr.ca>
In-Reply-To: <4752F6C7.4040904@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Jiri Kosina wrote:
>> On Sun, 2 Dec 2007, Mark Lord wrote:
>>
>>>> Single-clicking on things with 2.6.24 very frequently gives a 
>>>> "double-click". This does not happen with 2.6.23.8. I wonder what 
>>>> broke it? I've grabbed mousedev.c from 2.6.23 and inserted that in 
>>>> place of the updated 2.6.24 source, but no change.  So it's not that 
>>>> file.
>>> Mmm.. reverting the entire drivers/hid directory to that from 2.6.23
>>> seems to have fixed the problem, so we now know it's in there somewhere.
> ...
> 
> Mmmm.. an update here:
> 
> Reverting the drivers/hid directory does seem to improve behaviour.
> 
> But right now I have a "make -j4" happening in the background
> and the mouse is ever so erratic again, despite the drivers/hid reversion.
..
Ghad.. now that the "make -j4" has finished, the mouse is *still* screwy,
whereas it was mostly fine before the "make -j4" started.

Time to reboot (for the new kernel, as well as to try and fix the mouse).


