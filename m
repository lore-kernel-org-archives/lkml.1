Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbXEILXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbXEILXD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 07:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbXEILWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 07:22:53 -0400
Received: from [85.194.72.106] ([85.194.72.106]:32848 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750888AbXEILWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 07:22:52 -0400
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 May 2007 07:22:49 EDT
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v10
Date: Wed, 9 May 2007 14:21:42 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200705091421.42724.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>
> i'm pleased to announce release -v10 of the CFS scheduler patchset.
> (The main goal of CFS is to implement "desktop scheduling" with as
>  high quality as technically possible.)


Thanks!  I like this one a lot.

There is one workload that is still handled a bit strange, though.  Try 
running '# ping 10.1 -A > /dev/null' x3000.  Thread creation is great until 
it hits a wall around 950, bringing system response to a screaching halt.  
Setting sched_load_smoothing from 7/8 to 1, moves the wall to around 2100, 
which is great, but where do these walls come from?


Thanks!

--
Al

