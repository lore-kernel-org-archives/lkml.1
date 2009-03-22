Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbZCVLmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbZCVLmv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 07:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbZCVLmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 07:42:42 -0400
Received: from 1wt.eu ([62.212.114.60]:1393 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954AbZCVLml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 07:42:41 -0400
Date: Sun, 22 Mar 2009 12:42:37 +0100
From: Willy Tarreau <w@1wt.eu>
To: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Test some kernel feature without recompile
Message-ID: <20090322114237.GB570@1wt.eu>
References: <2d05c4580903220343l4b1359fx79f18b56203bd463@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d05c4580903220343l4b1359fx79f18b56203bd463@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 22, 2009 at 11:43:28AM +0100, Dragoslav Zaric wrote:
> Hi,
> 
> I know when you work on some kernel module, you can change code and load
> module again and test it, but what if you change some built in kernel
> .c file, why
> would I need to recompile whole kernel just to see what happens if I change one
> .c file ??
> 
> Why can I just compile one changed .c file and copy it where compiled version of
> that file reside inside kernel tree? Or maybe there is some image info embedded
> inside compiled files, so that file must belong to specific image from
> which it is
> installed ?

Well, in some cases you can do that. For very minor changes (constants,
disabling 'if' statements, breaking out of loops, or returning from
functions), tampering the memory with an hex editor is often more
convenient than rebooting. /proc/ksyms is your friend here. It also
sometimes help you see the effect of your changes. But you must always
be ready to reboot anyway because mistakes are quite common and generally
don't leave you with a second chance.

Willy

