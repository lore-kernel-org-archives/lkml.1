Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbZCKSVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbZCKSVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 14:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbZCKSVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 14:21:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753341AbZCKSVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 14:21:17 -0400
Date: Wed, 11 Mar 2009 11:19:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: Laurent GUERBY <laurent@guerby.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.29-rc5][BUG] swapon on vfat file gets stuck on inode lock
In-Reply-To: <874oy0orld.fsf@devron.myhome.or.jp>
Message-ID: <alpine.LFD.2.00.0903111119250.32478@localhost.localdomain>
References: <1236779832.11347.2082.camel@localhost> <alpine.LFD.2.00.0903110837590.32478@localhost.localdomain> <87ocw80z6s.fsf@devron.myhome.or.jp> <874oy0orld.fsf@devron.myhome.or.jp>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 12 Mar 2009, OGAWA Hirofumi wrote:
> 
> Ok. Simple stress test was done. BTW, since fat caches the metadata on
> that path, fat would be sensitive to race more than other fs.
> 
> Anyway, if you are ok, please apply. Otherwise, I'm going to prepare for
> this patch to next merge window.

It looks good to me, and obviously safer than my version. Will apply.

Thanks,

		Linus
