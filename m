Return-Path: <linux-kernel-owner+w=401wt.eu-S1423023AbXD3FQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423023AbXD3FQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 01:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423028AbXD3FQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 01:16:53 -0400
Received: from [212.12.190.16] ([212.12.190.16]:32828 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423023AbXD3FQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 01:16:53 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v7
Date: Mon, 30 Apr 2007 08:20:49 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200704300820.49078.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>
> i'm pleased to announce release -v7 of the CFS scheduler patchset. (The
> main goal of CFS is to implement "desktop scheduling" with as high
> quality as technically possible.)
:
:
> As usual, any sort of feedback, bugreport, fix and suggestion is more
> than welcome,

This one seems on par with SD, but there are still some nice issues.

Try running 3 chew.c's, then renicing one to -10, starves others for some 
seconds while switching prio-level.  Now renice it back to 10, it starves 
for up to 45sec.

Also, nice levels are only effective on every other step; ie:
 ... -3/-2 , -1/0 , 1/2 ... yields only 20 instead of 40 prio-levels.


Thanks!

--
Al

