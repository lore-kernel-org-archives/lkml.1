Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYG1FMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYG1FMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 01:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750920AbYG1FMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 01:12:09 -0400
Received: from relay2.sgi.com ([192.48.171.30]:46215 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750795AbYG1FMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 01:12:08 -0400
Date: Mon, 28 Jul 2008 00:12:05 -0500
From: Paul Jackson <pj@sgi.com>
To: Paul Jackson <pj@sgi.com>
Cc: lizf@cn.fujitsu.com, akpm@linux-foundation.org, menage@google.com,
       seto.hidetoshi@jp.fujitsu.com, laijs@cn.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] cpuset: clean up cpuset hierarchy traversal code
Message-Id: <20080728001205.f3801aca.pj@sgi.com>
In-Reply-To: <20080727233746.7f057e74.pj@sgi.com>
References: <488D332A.1030008@cn.fujitsu.com>
	<20080727233746.7f057e74.pj@sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pj wrote:
> Can you figure out if we are holding any system wide lock, such as
> cgroup_mutex, at this point?

Nevermind ... this is in rebuild_sched_domains(), which must be
called with cgroup_mutex held.  So we danged well better be holding
a system wide lock.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
