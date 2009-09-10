Return-Path: <linux-kernel-owner+w=401wt.eu-S1751862AbZIJPR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbZIJPR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 11:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbZIJPRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 11:17:55 -0400
Received: from baron.coraid.com ([12.51.113.4]:40993 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751726AbZIJPRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 11:17:55 -0400
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Thu, 10 Sep 2009 11:16:42 -0400
To: jens.axboe@oracle.com, ecashin@coraid.com, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org, apw@canonical.com, bonbons@linux-vserver.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aoe: end barrier bios with EOPNOTSUPP
Message-ID: <84f18127dcdb4762bf9dc6796846087f@coraid.com>
In-Reply-To: <20090910074820.GS18599@kernel.dk>
References: <20090904183525.GB18599@kernel.dk>
	<f48e25c99e41e375f2ddd85989cd39e1@coraid.com>
	<20090905051735.GH18599@kernel.dk>
	<366469f19c41e0150028b886f6859019@coraid.com>
	<20090908193540.GB18599@kernel.dk>
	<60772f633c524ba873f569966fccd6ce@coraid.com>
	<20090909180804.3e62331a@lxorguk.ukuu.org.uk>
	<30b7855d211ab5b6bef6fe2cd9b76295@coraid.com>
	<20090909205835.GK18599@kernel.dk>
	<810bbe1723b0a205f9b5018a5ddaa722@coraid.com>
	<20090910074820.GS18599@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu Sep 10 03:48:22 EDT 2009, jens.axboe@oracle.com wrote:
> On Wed, Sep 09 2009, Ed Cashin wrote:
...
> > If I had a reproducable problem case that the barrier implementation
> > could fix, it would be very helpful.
> 
> Depending on timing and the other end, it may not be easy to reproduce.
> But the problem is indeed real, so I think you should just add the
> proper barrier implementation instead of spending too much time trying
> to create a reproducable problem. By the time you get there, you could
> have fixed it many times over :-)

OK. I will start work on it.  But if anybody can give me a torture
test that works on aoe devices, I'll be grateful.

I think the EOPNOTSUPP patch is good for the for-next aoe quilt tree,
while the new barrier support will be good for 2.6.32.

-- 
  Ed
