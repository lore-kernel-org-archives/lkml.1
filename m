Return-Path: <linux-kernel-owner+w=401wt.eu-S1765904AbXGKRy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765904AbXGKRy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 13:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759108AbXGKRyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 13:54:16 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:32843 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758617AbXGKRyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 13:54:15 -0400
Message-ID: <46951941.9080908@acm.org>
Date: Wed, 11 Jul 2007 11:54:09 -0600
From: Zan Lynx <zlynx@acm.org>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
References: <200707111916.35036.jesper.juhl@gmail.com>
In-Reply-To: <200707111916.35036.jesper.juhl@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Envelope-From: zlynx@acm.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> Hi,
>
> I'm wondering if it's time to make 4K stacks the default and to start 
> considering removing the 8K stack option alltogether soon?
>
> One of the big problem spots was XFS, but that got some stack usage 
> fixes recently, and the 4K stack option has been around for quite a 
> while now, so people really should have gotten around to fixing any 
> code that can't handle it.   Are there still any big problem areas 
> remaining?
>   
Has anyone fixed the infrequent crashes with 4K stacks and ext3 -> LVM 
snapshot -> LVM -> DM mirror -> libata?

The latest (as of 150 days ago) Fedora 6 32-bit kernels crashed every 
week or two, the 64-bit kernel, which I believe uses 8K stacks, has been 
up 150 days.
