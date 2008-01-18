Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbYARJk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbYARJk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 04:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754939AbYARJkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 04:40:13 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55500 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792AbYARJkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 04:40:11 -0500
To: salikhmetov@gmail.com
CC: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, protasnb@gmail.com, miklos@szeredi.hu,
       r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com, hch@infradead.org
In-reply-to: <12006091182260-git-send-email-salikhmetov@gmail.com> (message
	from Anton Salikhmetov on Fri, 18 Jan 2008 01:31:56 +0300)
Subject: Re: [PATCH -v6 0/2] Fixing the issue with memory-mapped file times
References: <12006091182260-git-send-email-salikhmetov@gmail.com>
Message-Id: <E1JFnho-0008TH-5G@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 18 Jan 2008 10:40:08 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 4. Performance test was done using the program available from the
> following link:
> 
> http://bugzilla.kernel.org/attachment.cgi?id=14493
> 
> Result: the impact of the changes was negligible for files of a few
> hundred megabytes.

Could you also test with ext4 and post some numbers?  Afaik, ext4 uses
nanosecond timestamps, so the time updating code would be exercised
more during the page faults.

What about performance impact on msync(MS_ASYNC)?  Could you please do
some measurment of that as well?

Thanks,
Miklos

