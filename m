Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbZEVO3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbZEVO3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 10:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755960AbZEVO3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 10:29:40 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:58471 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbZEVO3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 10:29:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aRI3iDzcU3DaSEvfzXSA6IEgN7oD6NiQO/H/SocQsRiHcw6XNovg2gsOkT6zWCriEl
         PZUNeFwcX25aKWmnTucgqSZvcUMzmLTdV2mkv5AqFYL/Eqmw2jdyrmaPM1JLQ65FeqQL
         etzMB3OJPqG2LOftFDSpl2PK2qO2T1fyjF9HY=
MIME-Version: 1.0
In-Reply-To: <20090522151235.26432fbc@lxorguk.ukuu.org.uk>
References: <ac3eb2510905211407l3aec14acx2572a2ad4e675b9@mail.gmail.com>
	 <Pine.LNX.4.44L0.0905211724050.3914-100000@iolanthe.rowland.org>
	 <1295ed070905220630q67c62569o9753425abf529742@mail.gmail.com>
	 <20090522144343.7b26b3a8@lxorguk.ukuu.org.uk>
	 <1295ed070905220652q55c65e8bx992940b626eecda3@mail.gmail.com>
	 <20090522151235.26432fbc@lxorguk.ukuu.org.uk>
Date: Fri, 22 May 2009 17:29:39 +0300
Message-ID: <1295ed070905220729l4c90e3f4le60743b1ab661ecf@mail.gmail.com>
Subject: Re: How to tell whether a struct file is held by a process?
From: Pantelis Koukousoulas <pktoss@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > Firstly can you explain *why* you think there is a problem ?
>> >
>>
>> I admit this could be a bias from the way I imagined the whole thing
>> to work before
>> this discussion. I think I can see how a userspace locking scheme based on port
>> numbers could avoid also the reset problem
>
> That was a serious request to understand what you think the problem is
> and what problem is worrying you. I'm deeply sceptical of the need for
> any kernel locking on this one but I'd like to understand better why you
> think there are some cases it would be needed.
>

I don't anymore think kernel locking is really needed for this part. I 'm sorry
if my answer did not sound as serious as your request.

So, as long as the kernel has a facility to allow assigning ports to userspace,
the rest can be arranged between the userspace processes in a cooperative
manner (and in fact this seems to be the only sufficiently clean way from what
I can tell).

Thanks,
Pantelis
