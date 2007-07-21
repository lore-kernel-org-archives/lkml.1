Return-Path: <linux-kernel-owner+w=401wt.eu-S934628AbXGUGgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934628AbXGUGgl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 02:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbXGUGgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 02:36:33 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:54426 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753264AbXGUGgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 02:36:32 -0400
Message-ID: <384999782.11861@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sat, 21 Jul 2007 14:36:29 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 6/7] radixtree: introduce radix_tree_scan_hole()
Message-ID: <20070721063629.GA7013@mail.ustc.edu.cn>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
References: <20070721044300.909424569@mail.ustc.edu.cn> <384993020.08966@ustc.edu.cn> <20070720224859.38aa0c21.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720224859.38aa0c21.akpm@linux-foundation.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 10:48:59PM -0700, Andrew Morton wrote:
> On Sat, 21 Jul 2007 12:43:06 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> 
> > Introduce radix_tree_scan_hole(root, index, max_scan) to scan radix tree
> > for the first hole. It will be used in interleaved readahead.
> 
> If you're ever feeling fantastically bored, please consider updating the
> userspace radix-tree test harness for this?  Cook up a couple of testcases
> for the new functionality?

Thanks for the reminding.  I'd add some test cases if I'm to optimize it.

But this _dumb_ scan function is obviously correct(and won't be too slow on
1M readahead).  In fact it is pretty suitable for testing the optimized one ;)

