Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab0BGWOX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 17:14:23 -0500
Received: from mail-iw0-f183.google.com ([209.85.223.183]:59452 "EHLO
	mail-iw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397Ab0BGWOW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 17:14:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=D8G0Jk42Ov1z9jO72JtyS08l0I0RFATOpsBnkMzmzaHxB1j9xpJYmP7yzdRPRyXdof
         2cwnvEQGPZYPtANk/KIVhKlFoxinq3IXVOGSPCRroRKUqZvxwphT8hmdrbW9qnftfKue
         jxHHcHyeTfi9QTPwfn4/HZbb7AkQV9afxIvAY=
MIME-Version: 1.0
In-Reply-To: <45c77aec1002071056re61b8acg5f480f8ea83c68c@mail.gmail.com>
References: <45c77aec1002071056re61b8acg5f480f8ea83c68c@mail.gmail.com>
Date: Mon, 8 Feb 2010 09:14:21 +1100
Message-ID: <d45a3acc1002071414q318edea3m38f6d5ddbbd841bc@mail.gmail.com>
Subject: Re: Possible bug in insmod or the kernel?
From: andrew hendry <andrew.hendry@gmail.com>
To: Larry Homes <larr.homes@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

have a look around kernel/params.c
/* You can use " around spaces, but can't escape ". */
/* Hyphens and underscores equivalent in parameter names. */
static char *next_arg(char *args, char **param, char **val)

Your printks are probably showing the single quotes? probably not what
you want in your name

On Mon, Feb 8, 2010 at 5:56 AM, Larry Homes <larr.homes@gmail.com> wrote:
> Hello,
>
> I am very new to kernel development and I was playing around with
> making modules. I found I could not retrieve commandline parameters in
> the module if the parameter has whitespace in it. I thought it was my
> lack of knowledge that was causing the error (and I still do
> honestly), but I made a forum post here
> http://forum.kernelnewbies.org/read.php?17,1354 regarding the issue,
> and someone suggested it may be a bug and I should post on LKML.
>
> The forum post shows example code to demonstrate the issue. I am using
> archlinux and the latest kernel. I am not sure what other information
> you need, so feel free to ask for anything.
>
>
> Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
