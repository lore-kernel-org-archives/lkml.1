Return-Path: <linux-kernel-owner+w=401wt.eu-S1753134AbXCMGRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbXCMGRG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 02:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbXCMGRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 02:17:05 -0400
Received: from mail24.syd.optusnet.com.au ([211.29.133.165]:52351 "EHLO
	mail24.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753134AbXCMGRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 02:17:04 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: [ck] Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for  2.6.21-rc3-mm2
Date: Tue, 13 Mar 2007 17:16:31 +1100
User-Agent: KMail/1.9.5
Cc: michael chang <thenewme91@gmail.com>, ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200703111457.17624.kernel@kolivas.org> <b14e81f00703121438q6cdaffd0vdb08e0386961f057@mail.gmail.com> <1173766107.7944.76.camel@Homer.simpson.net>
In-Reply-To: <1173766107.7944.76.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703131716.31979.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 March 2007 17:08, Mike Galbraith wrote:
> Virtual or physical cores has nothing to do with the interactivity
> regression I noticed.  Two nice 0 tasks which combined used 50% of my
> box can no longer share that box with two nice 5 tasks and receive the
> 50% they need to perform.  That's it. From there, we wandered off into a
> discussion on the relative merit and pitfalls of fairness.

And again, with X in its current implementation it is NOT like two nice 0 
tasks at all; it is like one nice 0 task. This is being fixed in the X design 
as we speak.

> 	-Mike

-- 
-ck
