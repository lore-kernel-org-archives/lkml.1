Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbYHBLjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbYHBLjR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 07:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbYHBLjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 07:39:06 -0400
Received: from relay1.sgi.com ([192.48.171.29]:41115 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752644AbYHBLjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 07:39:05 -0400
Date: Sat, 2 Aug 2008 06:39:00 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, menage@google.com,
       a.p.zijlstra@chello.nl, vegard.nossum@gmail.com,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling
 (2.6.27-rc1)
Message-Id: <20080802063900.6615e5ca.pj@sgi.com>
In-Reply-To: <1217631552-22129-1-git-send-email-maxk@qualcomm.com>
References: <1217631552-22129-1-git-send-email-maxk@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Subject line suggests that this latest version of your patch should
apply on top of 2.6.27-rc1.  That does not seem to be quite accurate.

As stated in your previous message, it seems you're working on top of
Linus's latest git version, which, at least for the source file
kernel/cpuset.c, is (I suppose) more or less the same as 2.6.27-rc1
plus the 'origin.patch' that is at the top of Andrew's broken out quilt
patch series 2.6.27-rc1-mm1.

That origin.patch includes Li Zefan's patch:

  cpuset: clean up cpuset hierarchy traversal code

which Andrew recently sent along to Linus, and which patch is presumed
by this latest version of your patch.

I'll take a further look at your patch now.

We have lots of trees, including various from Ingo, linux-next, Andrew,
and Linus, each in many versions.  It helps others if you can state
exactly what tree/version a patch applies to, in each patch version
that you submit.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
