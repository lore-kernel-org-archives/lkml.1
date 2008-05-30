Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbYE3FZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbYE3FZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 01:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbYE3FY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 01:24:56 -0400
Received: from relay2.sgi.com ([192.48.171.30]:49997 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753011AbYE3FYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 01:24:55 -0400
Date: Fri, 30 May 2008 00:24:52 -0500
From: Paul Jackson <pj@sgi.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: miaox@cn.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [RFC] [PATCH 1/2] cpusets: restructure the function
 update_cpumask() and update_nodemask()
Message-Id: <20080530002452.e63983a1.pj@sgi.com>
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
> The nuance here is the difference in exported/non-exported vs. non-static/static.

Ok ... hmmm ... how to say this...

The documentation in Documentation/kernel-doc-nano-HOWTO.txt of
kernel-doc is mostly focused on the details of the apparatus that
converts the "/**" comments into various documenation formats, and has
only somewhat buried and non-inviting documentation for kernel hackers
wanting the "Kernel-Doc for Dummies" summary of how and when and where
to create such "/**" comments.

For example, the distinction you note between:
  !E<filename> external (EXPORT_SYMBOL), and
  !I<filename> internal (not exported)
is buried in the "How to make new SGML template files" section, which I
would hope that I never had to read.

However ... in accordance with the usual rule that he who complains
gets to fix it, I find this kernel-doc documentation to be PERFECT! ;).

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
