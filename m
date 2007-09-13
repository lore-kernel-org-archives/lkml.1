Return-Path: <linux-kernel-owner+w=401wt.eu-S1761808AbXIMPVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761808AbXIMPVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 11:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757095AbXIMPVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 11:21:11 -0400
Received: from rtr.ca ([76.10.145.34]:1390 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756335AbXIMPVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 11:21:09 -0400
Message-ID: <46E95563.5020704@rtr.ca>
Date: Thu, 13 Sep 2007 11:21:07 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Chuck Ebbert <cebbert@redhat.com>, Niels <zorglub_olsen@hotmail.com>,
       linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] Problems with USB disk [solved]
References: <Pine.LNX.4.44L0.0709131105250.3619-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0709131105250.3619-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Thu, 13 Sep 2007, Mark Lord wrote:
..
>> What happens is, there's a nice little LED on the Cruzer stick,
>> that is "lit" when the stick itself is not in a "power suspend" state
>> (or whatever you USB folks call it).
> 
> We call it "suspended".  (Wasn't there an episode of Classic Trek where 
> Mr. Spock explained to somebody, "I call them `ears'."?)
> 
>> On 2.6.22, that little LED stays "on" normally, and flickers off/on
>> when data is being transfered.
>>
>> The new "USB autosuspend" logic in 2.6.23 now causes that little LED
>> to turn off after a few seconds of inactivity.
>>
>> Once that happens, the USB stick is not accessible until after a longish
>> timeout (~30s I think), followed by a USB reset.  Then it is usable again
>> until the next inactivity timeout and autosuspend (a few seconds).
> 
> So this _isn't_ the regression described above -- to wit, that the 
> drive gets spun down and then won't work without first being spun back 
> up.  You wrote:
> 
>>>> My Sandisk Cruzer Micro 1GB USB sticks suffer from this regression.
> 
> But it doesn't.  It suffers from a different regression.

Perhaps, but that doesn't necessarily follow from the above.
>From this observer's point of view (and being an expert on disk technologies),
the same "spin up" issue for rotating media could be the culprit here too.

A reset to a disk drive usually (not always) causes it to spin up.

Regardless, Greg has acknowledged the regression and is planning to revert things.

Cheers
