Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbYE3D5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbYE3D5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 23:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbYE3D5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 23:57:12 -0400
Received: from relay1.sgi.com ([192.48.171.29]:33464 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752346AbYE3D5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 23:57:12 -0400
Date: Thu, 29 May 2008 22:57:08 -0500
From: Paul Jackson <pj@sgi.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: miaox@cn.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [RFC] [PATCH 1/2] cpusets: restructure the function
 update_cpumask() and update_nodemask()
Message-Id: <20080529225708.74f65654.pj@sgi.com>
In-Reply-To: <20080529203042.19f76f09.rdunlap@xenotime.net>
References: <483E564A.5050807@cn.fujitsu.com>
	<20080529031656.cdc38001.pj@sgi.com>
	<483F5DAA.5060004@cn.fujitsu.com>
	<20080529205344.4ba1efdb.pj@sgi.com>
	<483F6367.1040701@cn.fujitsu.com>
	<20080529212211.0e794c81.pj@sgi.com>
	<20080529203042.19f76f09.rdunlap@xenotime.net>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy wrote:
> For static functions, it's up to the maintainer/developer whether to do that
> or not.  But if the functions already have kernel-doc, there's no strong
> reason to remove it.  And these look good currently, so I see no
> good reason to change them.

Ok - thank-you for the explanation.

I had this vague recollection that kernel-doc was just for non-static
functions, so when I saw Miao put kernel-doc comments on a static
routine, I looked around to see if that was normal.

I didn't see mention of static functions in kernel-doc-nano-HOWTO.txt,
and in a brief survey, didn't happen to see any static functions with
kernel-doc comments.  However my survey was so brief I even missed five
such functions in the file I maintain, kernel/cpuset.c.  So from that
I came to the (apparently flawed) conclusion that it didn't make sense
to kernel-doc static functions, and so advised Miao.

I don't quite see what purpose kernel-doc would have for static
functions, and am still concerned that such would (mildly) clutter the
presentation of the externally visible cpuset functions in which those
who just use cpusets would be interested.

It remains, of course, important to have good documentation of
functions, static or not, but I would expect developers working inside
the kernel/cpuset.c file to look for documentation of functions
static to that file within the code and comments of that file, not in
kernel-doc.

However I am just the cpuset maintainer, not a kernel-doc expert.

I remain inclined toward removing the kernel-doc markings on static
functions in kernel/cpuset.c, but if you wish, Randy, to make a renewed
appeal for me not to do so, I will happily honor that appeal.

Life is good either way when we are discussing how to annotate
documentation, rather than lamenting its absence.

If you, Randy, felt inclined to explain the value of kernel-doc comments
on file static functions in kernel-doc-nano-HOWTO.txt, that might be
valuable for the next person who travels this path.

Thank-you.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
