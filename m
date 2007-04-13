Return-Path: <linux-kernel-owner+w=401wt.eu-S1750719AbXDMABG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750719AbXDMABG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 20:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbXDMABG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 20:01:06 -0400
Received: from gw.goop.org ([64.81.55.164]:32964 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbXDMABF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 20:01:05 -0400
Message-ID: <461EC81D.6020609@goop.org>
Date: Thu, 12 Apr 2007 17:00:29 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Tim Yamin <plasmaroo@gentoo.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH UPDATE] deflate stack usage in lib/inflate.c
References: <461DED14.1070603@goop.org> <200704122321.23318.ak@suse.de> <461EB938.6080807@goop.org> <200704130102.30588.ak@suse.de>
In-Reply-To: <200704130102.30588.ak@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Yes, but then we should have seen more frequently, shouldn't we? I always
> run with the stack overflow check enabled and I don't think I ever saw 
> warnings in inflate.
>   

I guess the window is just while decompressing the root filesystem. 
Interrupts under Xen might be using a little more stack (~40-50 bytes?),
but its not a qualitative difference.  It might have more to do with
different timing.

    J
