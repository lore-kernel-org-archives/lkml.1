Return-Path: <linux-kernel-owner+w=401wt.eu-S1752005AbXCKUgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbXCKUgI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 16:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbXCKUgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 16:36:07 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:36544 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbXCKUgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 16:36:06 -0400
Date: Sun, 11 Mar 2007 21:35:50 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Cong WANG <xiyou.wangcong@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Style Question
In-Reply-To: <2375c9f90703110715v4278f83flbc9fce6c542472a5@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0703112134180.16857@yvahk01.tjqt.qr>
References: <2375c9f90703110715v4278f83flbc9fce6c542472a5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 11 2007 22:15, Cong WANG wrote:
>
> I have a question about coding style in linux kernel. In
> Documention/CodingStyle, it is said that "Linux style for comments is
> the C89 "/* ... */" style. Don't use C99-style "// ..." comments."
> _But_ I see a lot of '//' style comments in current kernel code.
>
> Which is wrong? The documentions or the code, or neither? And why?

The code. And because it's not always reviewed but silently pushed.

> Another question is about NULL. AFAIK, in user space, using NULL is
> better than directly using 0 in C. In kernel, I know it used its own
> NULL, which may be defined as ((void*)0), but it's _still_ different
> from raw zero.

In what way?

>So can I say using NULL is better than 0 in kernel?

On what basis? Do you even know what NULL is defined as in
(C, not C++) userspace? Think about it.


Jan
-- 
