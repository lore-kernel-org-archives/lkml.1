Return-Path: <linux-kernel-owner+w=401wt.eu-S1756990AbXGHSuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbXGHSuz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 14:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754626AbXGHSur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 14:50:47 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:54763 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754839AbXGHSuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 14:50:46 -0400
Date: Sun, 8 Jul 2007 20:51:15 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Some love to default profiler
Message-ID: <20070708185115.GQ3492@stusta.de>
References: <20070704213420.GA5864@martell.zuzino.mipt.ru> <9a8748490707041650s3b122007o46c8a34647b43af3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9a8748490707041650s3b122007o46c8a34647b43af3@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 01:50:27AM +0200, Jesper Juhl wrote:
> On 04/07/07, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>> 1) Drop __KERNEL__ out of profile.h. It contains only internal kernel 
>> stuff and
>>    not in exported headers list
>
> Even if it's not in the list of exported headers, does it really hurt
> to retain that extra safeguard?
>...

Safeguard for what?

And it has to be consistent, and current policy is to not have
#ifdef __KERNEL__'s in all not to userspace exported headers.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

