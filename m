Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbYEVQEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbYEVQEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 12:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbYEVQEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 12:04:38 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:35435 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbYEVQEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 12:04:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SkDIfQv+DMvMzkxGJ0CQO57DfawcPzyDj6M3hexGaHAA5OwYWGbCCysU1zAr5whqZ7k0jGV1RAEQ6j8GD6PabUFX7Op+FSSc1riHYjrr5jjxf78N3P9zO5kmqG9F2/uqikpe/WKv/36KCsiAbJysfnxh3LqvlgwGj9aJ1FQyAX0=
Message-ID: <ee101c360805220904h1c69db12q3048d0347d27c461@mail.gmail.com>
Date: Fri, 23 May 2008 00:04:35 +0800
From: "Shuduo Sang" <sangshuduo@gmail.com>
To: "Bosko Radivojevic" <bosko.radivojevic@gmail.com>
Subject: Re: Inserting code from userspace to kernel space
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <d6c8ef150805220541v711c5acahc60541e3fd9f44fc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d6c8ef150805220541v711c5acahc60541e3fd9f44fc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 8:41 PM, Bosko Radivojevic
<bosko.radivojevic@gmail.com> wrote:
> Hi!
>
> I'm looking for a way to insert code from user space to the kernel
> space, but without using kernel module. Actually, we are working on a
> system that has to allow end user to change part of code (one or two
> functions) that is executed from the kernel space.
>
> For now we have two different kernel modules, one exporting a function
> which another module uses. Process of compiling kernel module is quite
> ineligible for standard end user (along with the requirement to
> support multi platform cross compiling) compared to just cross
> compiling a simple code that doesn't use any libraries than libc.
>
> I know this sounds quite weird, but maybe there is a project that can help us ;)
>

actually you can implement a parser/interpretor, whatever you name it,
in kernel space. And you can send the
function code from user space to kernel space by device driver
interface. the parser can parse that and do something
practical function in kernel.

I have worked on a similar task in a product powered by linux. It works great.

> Sincerely,
> Bosko
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
