Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbYEZJzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbYEZJzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 05:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbYEZJyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 05:54:49 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:2786 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbYEZJyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 05:54:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZXAU1alH1hE2aEOR5AP2qqmRi9GcGMfaPP+GwbVVuvak9Mn2SMgmWQ20yfQRIwBgbaGKFHgUWM3K3sWcmAWn5lBlCE5GeHz/E4wrxuJAYrYywoAhc53O/C3KCiIucg8GSyrB6/8vdLgFBtK6vdMLy+avtbjmvqhlMbM0+K19LeU=
Message-ID: <df9815e70805260254i42e8651dnc54b1e5c6f5f383b@mail.gmail.com>
Date: Mon, 26 May 2008 17:54:38 +0800
From: "Jike Song" <albcamus@gmail.com>
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

Did you try systemtap?  It's available at:

http://sourceware.org/systemtap/

--
Thanks and regards,
Jike

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
> Sincerely,
> Bosko
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
