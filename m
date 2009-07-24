Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbZGXTWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbZGXTWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 15:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbZGXTWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 15:22:40 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:65299 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbZGXTWj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 15:22:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=AAtdFcwrAD0PrBmUhCexvYRZvZValCcP0mL5VqLmC66omUq8w/aun8e5WEaJLW6yZA
         fPOGbhi68dS+p7isQuYTSau6q69bVK+YutnBZgS0bR1dqelnmlZjVGhBL69TFVm9TXfv
         nvfJNf5RtXOHfdzkhMLN5sQBUFNtgel5yYWyY=
MIME-Version: 1.0
In-Reply-To: <f5a7b3810907240831t75a058a2m96abdc28a28c4365@mail.gmail.com>
References: <f5a7b3810907240831t75a058a2m96abdc28a28c4365@mail.gmail.com>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Fri, 24 Jul 2009 12:16:21 -0700
X-Google-Sender-Auth: 9ec0306e4aaf50ff
Message-ID: <2c0942db0907241216p416ac5edyce0b41e29926ec29@mail.gmail.com>
Subject: Re: Char Limit issue on 2.6.29 kernels
To: naresh kamboju <naresh.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, tim.bird@am.sony.com,
       ltp-list@lists.sourceforge.net, brinda_mn@yahoo.co.in,
       rohit.170309@gmail.com, Garrett Cooper <yanegomi@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, maxin john <maxinbjohn@gmail.com>,
       Masatake YAMATO <yamato@redhat.com>, michal.simek@petalogix.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 8:31 AM, naresh kamboju <naresh.kernel@gmail.com> wrote:
>
> Hi,
>
> I have come across with char Limit issue on 2.6.29 kernels.
>
>
> SIGFAULT:
>
> #define SIZE            8053759
> char buf1[SIZE] ;
>
> NO SIGFAULT:
>
> #define SIZE            8053758
> char buf1[SIZE] ;
>
> This SIGFAULT not observed on 2.6.23 kernels.
>
> What could be the changes that effecting from 2.6.23 to 2.6.29 kernels.
> Please share me the information.

is "ulimit -a" the same on both kernels?

Can you provide a small program that shows the issue?
