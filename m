Return-Path: <linux-kernel-owner+w=401wt.eu-S1757688AbZCJVdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688AbZCJVdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 17:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbZCJVdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 17:33:11 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:34642 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbZCJVdJ (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 17:33:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fsEXFtodaJ0mbRuyQ/krIENodera88jsVWgbtoMqzqQZuv2LjBlK3ub902TYRlBEjN
         UHtG4U4tEdiG84NjndzRlIzLEFqZT2CXGivT0+9JX5ShdMuoh+mNVhMYL5h+KNpG8JGB
         IQAZxEyp1jO6WRAlW1Ciohi7W6z1E3DIFqraM=
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.0903101149500.25436@vixen.sonytel.be>
References: <49AF30EC.8010205@lougher.demon.co.uk>
	 <200903092239.13078.s.L-H@gmx.de>
	 <49B5CCB7.5030404@lougher.demon.co.uk>
	 <alpine.LRH.2.00.0903101149500.25436@vixen.sonytel.be>
Date: Tue, 10 Mar 2009 21:33:06 +0000
Message-ID: <cce9e37e0903101433r68f6140and965959f9063e798@mail.gmail.com>
Subject: Re: [GIT PULL] Squashfs fixes for 2.6.29?
From: Phillip Lougher <phil.lougher@gmail.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
       Stefan Lippers-Hollmann <s.L-H@gmx.de>, Linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> On Tue, 10 Mar 2009, Phillip Lougher wrote:
>> Stefan Lippers-Hollmann wrote:
>>> This patch seems to break squashfs for me on i386 and amd64.
>>> Test environment is a squashed filesystem image (live CD image, but also
>>> tested manually with a loop mounted iso9660 and loop mounted squashfs;
>>> kernel 2.6.29-rc7-git2). The squashfs image has been created with
>>> squashfs-tools CVS[1] as of today (latest commit 2009-03-03).
>>>
>> Can you send me a filesystem (or link to one) which exhibits this?  Zlib is
>> obviously showing unexpected behaviour...
>
> I see the same thing here. I'll send you a test file system by private email.
>

OK thanks, I've received it, and reproduced the problem :-)

> The patch below fixes it. It seems zlib sometimes does need an additional
> loop ;-)
>

Yes thanks.

> Note that I expect it may now loop forever in case of file system corruption.

This is the next thing, to redo the file system corruption patch.

Thanks

Phillip
