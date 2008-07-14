Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbYGNBrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbYGNBrw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 21:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbYGNBrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 21:47:45 -0400
Received: from ozlabs.org ([203.10.76.45]:50892 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008AbYGNBro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 21:47:44 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -next 00/11] remove CONFIG_KMOD
Date: Mon, 14 Jul 2008 10:38:49 +1000
User-Agent: KMail/1.9.9
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
References: <20080709082834.942992000@sipsolutions.net> <87zlolzv15.fsf@basil.nowhere.org>
In-Reply-To: <87zlolzv15.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807141038.49652.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 July 2008 01:03:02 Andi Kleen wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> > I've rebased this patch series against -next-20080708 (one conflict
> > against ftrace, another against BKL pushdown) and fixed the things
> > Adrian Bunk pointed out.
>
> You forgot to say why you want to remove that?
>
> I personally like to not set CONFIG_KMOD because the auto loader
> tends to load way too many modules. e.g. currently when someone requests
> aes on x86 you get three different aes modules (including VIA PadLock
> aes and an unoptimized C version), and keeping those around
> is just a waste.

Well, if you're building your own kernel anyway, don't build modules you don't 
want.

> Also if I didn't load a driver I prefer if it's not loaded at all.
> This is also useful for power saving for example where it's better
> to keep modules not loaded that you don't need and it's hard to
> control who accesses the respective devices.
>
> Please keep the option.

"echo /bin/true > /proc/sys/kernel/modprobe".

Given that, I don't think the config option is useful any more.

Rusty.
