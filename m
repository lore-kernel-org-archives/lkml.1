Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbZB1HzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbZB1HzO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 02:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbZB1HzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 02:55:00 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:26541 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbZB1Hy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 02:54:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NasyUc6vq7MCoPdSKmSou+fqlumQ2BD+G6he9F5mFHB5c53wuzlkK0hqKWOys6l6KJ
         HBcB+DF/CK0hw2X3b96XQsJ9Cm/YHPMihiPPGjGXFBIFfLjOJtbZfudNag+rdhoFm0FA
         lZ/RftuuwdGiid71VJxEjHB9oP3GDjbrFvmjc=
MIME-Version: 1.0
In-Reply-To: <20090228074740.GA7581@localhost>
References: <1235785882-17580-1-git-send-email-jeremy@goop.org>
	 <1235785882-17580-4-git-send-email-jeremy@goop.org>
	 <86802c440902272302n3787b2bex3741b46a372a19b0@mail.gmail.com>
	 <49A8E235.6010900@goop.org> <20090228071534.GB9351@elte.hu>
	 <49A8EA1A.50802@kernel.org> <20090228074740.GA7581@localhost>
Date: Fri, 27 Feb 2009 23:54:57 -0800
X-Google-Sender-Auth: 90b8bf15f436a41f
Message-ID: <86802c440902272354s147aa88x2be99b48f2097b67@mail.gmail.com>
Subject: Re: does boot loader check uncompressed kernel size?
From: Yinghai Lu <yinghai@kernel.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 11:47 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> [Yinghai Lu - Fri, Feb 27, 2009 at 11:39:06PM -0800]
> | wonder if boot loader check uncompress size aka vmlinux size in bzImage
> | before it find one good position for bzImage...?
> |
> | YH
> |
>
> At least for x86-64 in grub-1.96 I didn't find such a check.
> Btw, but why should it care? Or you mean something else?

thinking about Jeremy's brk patches that may use ram after _end blindly...

YH
