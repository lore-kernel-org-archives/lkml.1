Return-Path: <linux-kernel-owner+w=401wt.eu-S932467AbXHQVb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467AbXHQVb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 17:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932241AbXHQVas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 17:30:48 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:34278 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765916AbXHQVaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 17:30:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UA42tAqgMQED+RVnNhwegHhd9xyTkacFmevEbLPEgjeXwYI5oljKryO2M8u/hul+GggLiHex8Y1B7rp3/bbw0JY3N14HnJrD0II7JnNhA5AWHzXVnWoNkoQiW9PGjlHJqfMZl8nBLK5daN396GSeSKiPW5+g6pCwLxLNVBYXoRI=
Message-ID: <9a8748490708171430u2be506canf640d5c8c97149c6@mail.gmail.com>
Date: Fri, 17 Aug 2007 23:30:45 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Xu Yang" <risingsunxy@googlemail.com>
Subject: Re: how to add debug information into the vmlinux
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <ab40e9c0708171349n73e35f58p5f5c092b54ddeb45@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ab40e9c0708171349n73e35f58p5f5c092b54ddeb45@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/08/07, Xu Yang <risingsunxy@googlemail.com> wrote:
> Hello everyone,
>
> I am trying to port kernel 2.6.19 onto my system.so I need the c code
> , which can show me where the program is running. I add -g when I
> compile it.
>
You shouldn't need to do that manually, simply go into "make
menuconfig", enter the "Kernel hacking" menu and select the "Kernel
debugging" and "Compile the kernel with debug info" options.
You may also want to enable "Compile the kernel with frame pointers"
and various other options in that menu to get more debug info.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
