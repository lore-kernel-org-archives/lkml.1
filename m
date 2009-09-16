Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbZIPIpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbZIPIpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 04:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757605AbZIPIpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 04:45:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53144 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbZIPIpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 04:45:13 -0400
Date: Wed, 16 Sep 2009 10:45:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: stack limits [was Re: 2.6.32 -mm merge plans]
Message-ID: <20090916084506.GA6862@elf.ucw.cz>
References: <20090915161535.db0a6904.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915161535.db0a6904.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> - If you were bcc'ed on this email then you and I have unfinished
>   business.  Please see if you can work out what it is from the below and
>   let me know ;)

Was it this?

> #fdpic-ignore-the-loaders-pt_gnu_stack-when-calculating-the-stack-size.patch: pavel unhappy
> fdpic-ignore-the-loaders-pt_gnu_stack-when-calculating-the-stack-size.patch
> 
>   Elf.  Merge.  See if we can make Pavel happy.

It is not a big deal either way -- it is mostly theoretical -- but the
old code seems to be safer in those corner cases. I don't understand
why they are pushing it really.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
