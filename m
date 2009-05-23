Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbZEWWnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbZEWWnY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 18:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZEWWnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 18:43:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38195 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200AbZEWWnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 18:43:15 -0400
Message-ID: <4A187BDE.5070601@redhat.com>
Date: Sat, 23 May 2009 18:42:38 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Larry H." <research@subreption.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       pageexec@freemail.hu
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page	allocator
References: <20090520183045.GB10547@oblivion.subreption.com> <4A15A8C7.2030505@redhat.com> <20090522073436.GA3612@elte.hu> <20090522113809.GB13971@oblivion.subreption.com> <20090523124944.GA23042@elte.hu>
In-Reply-To: <20090523124944.GA23042@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> What you are missing is that your patch makes _no technical sense_ 
> if you allow the same information to leak over the kernel stack. 
> Kernel stacks can be freed and reused, swapped out and thus 
> 'exposed'.

Kernel stacks may be freed and reused, but Larry's latest
patch takes care of that by clearing them at page free
time.

As for being swapped out - I do not believe that kernel
stacks can ever be swapped out in Linux.

-- 
All rights reversed.
