Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345Ab0CNQMN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 12:12:13 -0400
Received: from mail-iw0-f176.google.com ([209.85.223.176]:48553 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab0CNQMI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 12:12:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=R0K3izBLI8Lh5v263yNL6LlWNteMl3jPlcRwfJ49LcFhKRlGmErOsQMsS3VUwDmbfG
         JHdzlS2zwyOOr6MK1Ts+S/b3eOgLa94o7y+Jti4jQ1ODCCx5MBqDS8OziBIDfPdxOG1b
         DjPfZs0TYz74VnyqRvEiSYvKb6iMStnL6PKFs=
MIME-Version: 1.0
In-Reply-To: <4B9D0879.5050809@teksavvy.com>
References: <f875e2fe1003032052p944f32ayfe9fe8cfbed056d4@mail.gmail.com>
	 <20100303224245.ae8d1f7a.akpm@linux-foundation.org>
	 <87f94c371003040617t4a4fcd0dt1c9fc0f50e6002c4@mail.gmail.com>
	 <4B8FC6AC.4060801@teksavvy.com>
	 <87f94c371003111029s7c7daebgf691ab11e6bdda25@mail.gmail.com>
	 <4B9D0879.5050809@teksavvy.com>
Date: Sun, 14 Mar 2010 12:12:06 -0400
Message-ID: <87f94c371003140912g1a567458ic2d78da6eed7fdb3@mail.gmail.com>
Subject: Re: Linux kernel - Libata bad block error handling to user mode 
	program
From: Greg Freemyer <greg.freemyer@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, foo saa <foosaa@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 14, 2010 at 12:02 PM, Mark Lord <kernel@teksavvy.com> wrote:
> On 03/11/10 13:29, Greg Freemyer wrote:
>>>
>>> But really.. isn't "hdparm --security-erase NULL /dev/sdX" good enough
>>> ???
>>>
>>
>> This thread seems to have died off.  If there is a real problem, I
>> hope it picks back up.
>>
>> Mark, as to your question the few times I've tried that the bios on
>> the test machine blocked the command.  So it may have some specific
>> utility, but it's a not a generic solution in my mind.
>
> ..
>
> Yeah, a lot of BIOSs do a "SECURITY FREEZE" command before booting,
> which disables things like "SECURITY ERASE" until the next hard reset.
>
> So, on a Linux system, just unplug the drive after booting, replug it,
> and usually it can then be erased.

I have a client that wipes 10,000+ drives a month. (They do this as a
service to banks, etc. as the machines they're in are retired, so they
use 10,000+ machines to wipe those 10,000+ drives.)

They tend not to open the case, just boot via PXE/USB/CD and run a wiping tool.

Opening the case to do as you propose is not really acceptable.  Also
they still have a lot of IDE inside those retiring machines.

fyi: If the wipe fails for whatever reason, they do open the case and
physically remove/disable/sanitize the drive.

Greg
