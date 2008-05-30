Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbYE3P5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbYE3P5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 11:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbYE3P5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 11:57:04 -0400
Received: from relay2.sgi.com ([192.48.171.30]:34802 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752084AbYE3P5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 11:57:02 -0400
Date: Fri, 30 May 2008 10:56:58 -0500
From: Paul Jackson <pj@sgi.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: miaox@cn.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [PATCH 2/3] cpusets: restructure the function update_cpumask()
 and update_nodemask()
Message-Id: <20080530105658.1b2f4839.pj@sgi.com>
In-Reply-To: <20080530105302.0f447003@core>
References: <483FAE13.5080101@cn.fujitsu.com>
	<20080530105302.0f447003@core>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
> Trivial only: The kernel-doc bits should be /**, 3 of them.

It took me a minute to parse this comment (pre-coffee morning fog ;).

I take it that you're noticing, Alan, that the header comments for
the functions update_tasks_cpumask() and update_tasks_nodemask(), and
perhaps one other function, are already in kernel-doc format, except
for one detail -- they currently open with '/*' instead of '/**',
and you're recommending the trivial change '/*' ==> '/**' for these
cases.

Yes - Miao commented these new functions in kernel-doc format, all but
the '/**', by my request, which now stands NAQ'd.

So, yes, '/**' should be used on any kernel/cpuset.c function comment
that is otherwise already in kernel-doc format.

Again, thank-you.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
