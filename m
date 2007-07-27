Return-Path: <linux-kernel-owner+w=401wt.eu-S937428AbXG0PL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937428AbXG0PL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 11:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934460AbXG0PLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 11:11:49 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:40642 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933576AbXG0PLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 11:11:48 -0400
Subject: Re: 2.6.23-rc1-mm1: reiser4 <-> lzo compile error
From: Richard Purdie <rpurdie@openedhand.com>
To: Edward Shishkin <edward@namesys.com>
Cc: Adrian Bunk <bunk@stusta.de>, Nitin Gupta <nitingupta910@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       reiserfs-devel@vger.kernel.org
In-Reply-To: <46A9E691.5080308@namesys.com>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
	 <20070725182221.GG3572@stusta.de>  <46A9E691.5080308@namesys.com>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 16:11:28 +0100
Message-Id: <1185549088.6148.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-27 at 16:35 +0400, Edward Shishkin wrote:
> Sorry, guys, I am not happy with the modified LZO:
> the compressor tries to test bytes which are out of bounds.
> 
> The attached module testlzo.c causes an oops in the second pass:
> AFAIK, both, @m and @m_pos should be in [wrkmem, wrkmem + 64K);
> I have attached trace.txt with their actual values.
> 
> Not ready to migrate to this library.
> 
> Any ideas?

I can confirm its broken, it give an oops on ARM 2.6.23-rc1 too in the
first pass.

I guess the only real solution now is to compare the byte code from the
new and original and find out where this problem has crept in from and
check there are no others. I'll look into it but its going to take time.
There goes my weekend :-(

Richard

