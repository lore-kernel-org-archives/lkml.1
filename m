Return-Path: <linux-kernel-owner+w=401wt.eu-S1757328AbZEVNwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbZEVNwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 09:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbZEVNwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 09:52:23 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:36330 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbZEVNwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 09:52:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C4VFpe8juO/GQzZ3T+1fuBkiJfXIYTdcEs/N0ERkuK1TCKMVi9lSK1nR52VBCkoVvd
         fzhxlKZmTufxpL2sVAIAHWpVdtG33baOH2M9YxdnVcBcVtgdsPmcG0HWTadiMyYbwVsG
         qxiIJvTa4c1hnORmXgAd9gHeZVHLzsS4UfrUc=
MIME-Version: 1.0
In-Reply-To: <20090522144343.7b26b3a8@lxorguk.ukuu.org.uk>
References: <ac3eb2510905211407l3aec14acx2572a2ad4e675b9@mail.gmail.com>
	 <Pine.LNX.4.44L0.0905211724050.3914-100000@iolanthe.rowland.org>
	 <1295ed070905220630q67c62569o9753425abf529742@mail.gmail.com>
	 <20090522144343.7b26b3a8@lxorguk.ukuu.org.uk>
Date: Fri, 22 May 2009 16:52:23 +0300
Message-ID: <1295ed070905220652q55c65e8bx992940b626eecda3@mail.gmail.com>
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

On Fri, May 22, 2009 at 4:43 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Suppose a device needs a reset as part of its init sequence (a whole lot
>> of them do, this is not purely hypothetical). Then a different process may
>> get to operate the device before and after the reset and hilarity may result
>> from that.
>
> Thats surely up to you to get your lock file usage right. The kernel
> isn't there to play mother to crap programming.

Who is "me" in this case? Assuming that those writing the userspace programs
are cooperative though, I agree. We can declare that whatever program does not
play by the (userspace locking) rules is crap and either fix it (if open source)
or refuse to install it / complain (if closed source).

>
>> So, if there is a clean / acceptable way to handle the reset issue in userspace
>
> Firstly can you explain *why* you think there is a problem ?
>

I admit this could be a bias from the way I imagined the whole thing
to work before
this discussion. I think I can see how a userspace locking scheme based on port
numbers could avoid also the reset problem.

Thanks,
Pantelis
