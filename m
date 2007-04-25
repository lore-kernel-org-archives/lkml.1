Return-Path: <linux-kernel-owner+w=401wt.eu-S2992823AbXDYQXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992823AbXDYQXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 12:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992828AbXDYQXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 12:23:12 -0400
Received: from [70.254.190.220] ([70.254.190.220]:56544 "EHLO server.willdawg"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992823AbXDYQXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 12:23:10 -0400
Date: Wed, 25 Apr 2007 16:23:09 +0000 (GMT)
From: William Heimbigner <icxcnika@mar.tar.cc>
X-X-Sender: icxcnika@server.thyself
To: Pavel Machek <pavel@ucw.cz>
cc: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>, Al Boldi <a1426z@gawab.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Reasons to merge suspend2.
In-Reply-To: <20070425161656.GA17253@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0704251620240.25153@server.thyself>
References: <200704251551.38373.a1426z@gawab.com>
 <alpine.DEB.0.98.0704251111000.18512@sigma.j-a-k-j.com>
 <Pine.LNX.4.64.0704251600030.25153@server.thyself> <20070425161656.GA17253@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007, Pavel Machek wrote:

> Hi!
>
>>>> I didn't read your whole post, it's way too long, but I would like to see
>>>> your patch in mainline as an option to swsusp.  What would make this
>>>> infeasible?
>>>
>>> For one thing, Linus said not but yesterday that he doesn't want multiple
>>> competing suspend algorithms like this in the kernel at once. (If I parsed
>>> his message correctly, he doesn't want any in the kernel, but he's putting
>>> up with it because it seems somewhat needed.)
>>
>> Would it be a feasible solution to have a very minimal and generic software
>> suspend in the kernel, and then various userspace implementations could
>> take care of this?
>
> Yes please. If you want suspend-over-nfs or whatever, just add it to
> the userspace; we have enough support in kernel now.
> 									Pavel

That seems like a rather asinine idea to implement. I think you misread my 
question - there are some things that have to be done at the kernel level, such 
as when the entire memory has to be written, but are there portions of the 
existing code, or portions of Suspend2, that could be done in userspace?

If so, you could have a generic suspend mechanism in the kernel, and then 
various other things done in userspace.

William Heimbigner
icxcnika@mar.tar.cc
