Return-Path: <linux-kernel-owner+w=401wt.eu-S1750773AbXBWDEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750773AbXBWDEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 22:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbXBWDEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 22:04:21 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4820 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbXBWDEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 22:04:21 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 22 Feb 2007 19:04:18 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Dong Feng <middle.fengdong@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Why __syscallN macros are removed?
In-Reply-To: <a2ebde260702221847q6710be1sbf2d28f37ab4fb2b@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0702221903490.1356@alien.or.mcafeemobile.com>
References: <a2ebde260702221847q6710be1sbf2d28f37ab4fb2b@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Feb 2007, Dong Feng wrote:

> The __syscallN series macros have disappeared in
> include/asm-i386/unistd.h. Why? I occasionally what to add and use
> some new system calls, mainly for debug use. Now I can not access the
> system call I added from user space.

You can use glibc's syscall(2) instead of macros.



- Davide


