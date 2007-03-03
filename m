Return-Path: <linux-kernel-owner+w=401wt.eu-S1751222AbXCCHnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222AbXCCHnv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 02:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbXCCHnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 02:43:51 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:63480 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbXCCHnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 02:43:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HBrC/kwZxuOwVJ+YY/2BYCTjThUBdQ7BfJwsh38vy5iy4Oe5WRbXXpMomn9ju05Ld9Wk+BlOc/W/NC57LEicifGwEpaoXBKy2wOJBw/hqOdRRMnGKAsDjCUn3LVrONdKt2wPdNLExcFzN9S4CPkv1l72Tn5G5IGIxBiUomxqDyk=
Subject: Re: 2.6.21-rc2-mm1 - build error with CONFIG_NO_HZ=y and
	CONFIG_SMP=n
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070302030026.5eef0c92.akpm@linux-foundation.org>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Date: Sat, 03 Mar 2007 15:45:52 +0800
Message-Id: <1172907952.3088.3.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-02 at 03:00 -0800, Andrew Morton wrote:

I get this with CONFIG_NO_HZ=y, CONFIG_SMP=n

kernel/sched.c: In function ‘trigger_load_balance’:
kernel/sched.c:3384: error: ‘struct rq’ has no member named
‘in_nohz_recently’
kernel/sched.c:3384: error: ‘struct rq’ has no member named
‘idle_at_tick’
kernel/sched.c:3385: error: ‘struct rq’ has no member named
‘in_nohz_recently’
kernel/sched.c:3387: error: ‘nohz’ undeclared (first use in this
function)
kernel/sched.c:3387: error: (Each undeclared identifier is reported only
once
kernel/sched.c:3387: error: for each function it appears in.)
kernel/sched.c:3404: warning: implicit declaration of function
‘resched_cpu’
kernel/sched.c:3412: error: ‘struct rq’ has no member named
‘idle_at_tick’
kernel/sched.c:3422: error: ‘struct rq’ has no member named
‘idle_at_tick’
make[1]: *** [kernel/sched.o] Error 1
make: *** [kernel] Error 2

Tony

