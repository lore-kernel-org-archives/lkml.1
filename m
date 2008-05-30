Return-Path: <linux-kernel-owner+w=401wt.eu-S1760391AbYE3GZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760391AbYE3GZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 02:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbYE3GZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 02:25:41 -0400
Received: from relay1.sgi.com ([192.48.171.29]:58653 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754735AbYE3GZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 02:25:40 -0400
Date: Fri, 30 May 2008 01:25:37 -0500
From: Paul Jackson <pj@sgi.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: miaox@cn.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [RFC] [PATCH 1/2] cpusets: restructure the function
 update_cpumask() and update_nodemask()
Message-Id: <20080530012537.87454a8d.pj@sgi.com>
In-Reply-To: <20080529212746.2d9cae24.rdunlap@xenotime.net>
References: <483E564A.5050807@cn.fujitsu.com>
	<20080529031656.cdc38001.pj@sgi.com>
	<483F5DAA.5060004@cn.fujitsu.com>
	<20080529205344.4ba1efdb.pj@sgi.com>
	<483F6367.1040701@cn.fujitsu.com>
	<20080529212211.0e794c81.pj@sgi.com>
	<20080529203042.19f76f09.rdunlap@xenotime.net>
	<20080529225708.74f65654.pj@sgi.com>
	<20080529212746.2d9cae24.rdunlap@xenotime.net>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy wrote:
> Does that help?  your understanding of kernel-doc or your decision?

Well, I get the difference between E (exported) and I (non-exported)
now.  And I see that one could prepare documents using SGML templates
that contained one, or the other of these, for any kernel source files
of interest.

I'm stuck on the next step of this decision.

Usually, when I am preparing documens, I know what document I am
preparing and have an idea who is in its audience.

I have never seen or heard of a document using the "/**" kernel-doc
entries of kernel/cpuset.c, and I have no idea who actually has (in
the past or present, not just hypothetically) read such or why.

So I'm kinda shootin in the dark here.

So, mostly just to be consistent with my previous call, because I enjoy
being a stubborn retard, I continue to prefer that file static routines
in kernel/cpuset.c not have "/**" kernel-doc markers on their comments,
and I would still welcome a patch from Miao removing the ones already
there.

Enough of this discussion, from me at least.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
