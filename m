Return-Path: <linux-kernel-owner+w=401wt.eu-S1758705AbZJMB4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705AbZJMB4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 21:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbZJMBz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 21:55:59 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:52832 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbZJMBz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 21:55:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=AKD5za+msojOM0rFHS+B1AG9z9i+iQdQwjX+Nt8eYsWc4fQV0mZAYV/6AXRsxSuRkY
         ayZxOu4VyGVBLaeXOUhiOb9KgBDZpBqHBKlHC0Ph6L628cZKfpUa/qDJc5pi2kDRWPPH
         NCmK7baOEjw256/UEyLp0skqM6pPFzUcoyGxQ=
MIME-Version: 1.0
In-Reply-To: <4AD36022.4090300@nagafix.co.uk>
References: <4AD34542.7050500@nagafix.co.uk> <20091012160548.GA3961@hack>
	 <4AD36022.4090300@nagafix.co.uk>
Date: Tue, 13 Oct 2009 09:54:52 +0800
Message-ID: <2375c9f90910121854v72422318u6b8f67f4437e4066@mail.gmail.com>
Subject: Re: 2.6.31.2 broke UML 64-bit build (2.6.31 was fine)
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Antoine Martin <antoine@nagafix.co.uk>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 12:58 AM, Antoine Martin <antoine@nagafix.co.uk> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
>
>> Hmm, this is a known problem:
>> https://lists.linux-foundation.org/pipermail/bugme-new/2009-May/021900.html
> How odd that I have been compiling successfully all that time!
> Maybe the fact that it broke "more" recently will help you...

Please try this patch:

http://patchwork.kernel.org/patch/48759/

It should fix your problem.

What I can do here is to suggest -stable team to include this patch in the
next update for .31. Greg?
