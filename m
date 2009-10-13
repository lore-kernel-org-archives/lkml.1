Return-Path: <linux-kernel-owner+w=401wt.eu-S1758919AbZJMCy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbZJMCy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 22:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758910AbZJMCy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 22:54:56 -0400
Received: from mail-qy0-f186.google.com ([209.85.221.186]:48642 "EHLO
	mail-qy0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758906AbZJMCyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 22:54:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VtvQEFw0XEYqy8FZq8C+zWYoQqT6p1BgaPAqhiIIPguro97IAhLekcaDolagOu5S+N
         3rQStqtg9APSv0ef82J8ktrxuykzPZLRPQ92YV40kIB7qO5qCpC5mIsm0QFHdxhQo/4O
         +la76A9fTssNmZ5MxopOqynNjElZGkhNxoVVQ=
MIME-Version: 1.0
In-Reply-To: <20091013021238.GA13241@suse.de>
References: <4AD34542.7050500@nagafix.co.uk> <20091012160548.GA3961@hack>
	 <4AD36022.4090300@nagafix.co.uk>
	 <2375c9f90910121854v72422318u6b8f67f4437e4066@mail.gmail.com>
	 <20091013021238.GA13241@suse.de>
Date: Tue, 13 Oct 2009 10:54:19 +0800
Message-ID: <2375c9f90910121954h167d2396lea1f54a87c263869@mail.gmail.com>
Subject: Re: 2.6.31.2 broke UML 64-bit build (2.6.31 was fine)
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Antoine Martin <antoine@nagafix.co.uk>,
       LKML <linux-kernel@vger.kernel.org>, stable@kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 10:12 AM, Greg KH <gregkh@suse.de> wrote:
> On Tue, Oct 13, 2009 at 09:54:52AM +0800, Am??rico Wang wrote:
>> On Tue, Oct 13, 2009 at 12:58 AM, Antoine Martin <antoine@nagafix.co.uk> wrote:
>> > -----BEGIN PGP SIGNED MESSAGE-----
>> > Hash: SHA512
>> >
>> >> Hmm, this is a known problem:
>> >> https://lists.linux-foundation.org/pipermail/bugme-new/2009-May/021900.html
>> > How odd that I have been compiling successfully all that time!
>> > Maybe the fact that it broke "more" recently will help you...
>>
>> Please try this patch:
>>
>> http://patchwork.kernel.org/patch/48759/
>>
>> It should fix your problem.
>>
>> What I can do here is to suggest -stable team to include this patch in the
>> next update for .31. Greg?
>
> Send the git commit id of the patch that fixes the problem that is
> already in Linus's tree to stable@kernel.org and cc: me.

Thanks!

Below it is:

commit	51b563fc93c8cb5bff1d67a0a71c374e4a4ea049
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 20 Sep 2009 12:28:22 +0200
Subject: [PATCH 1/1] arm, cris, mips, sparc, powerpc, um, xtensa: fix
build with bash 4.0
