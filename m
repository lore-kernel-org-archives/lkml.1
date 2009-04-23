Return-Path: <linux-kernel-owner+w=401wt.eu-S1759914AbZDWPT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759914AbZDWPT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 11:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbZDWPTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 11:19:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37483 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbZDWPTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 11:19:46 -0400
Date: Thu, 23 Apr 2009 17:23:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Johannes Weiner <hannes@cmpxchg.org>,
       linux-kernel@vger.kernel.org, torvalds@osdl.org, akpm@osdl.org
Subject: Re: [PATCH] Eliminate thousands of warnings in WARN_ON with gcc 3.2 build
Message-ID: <20090423152323.GQ13896@one.firstfloor.org>
References: <20090422221134.GA1753@basil.nowhere.org> <20090423120219.GA23479@cmpxchg.org> <20090423122327.GN13896@one.firstfloor.org> <20090423143859.GA20453@cmpxchg.org> <20090423151024.GO13896@one.firstfloor.org> <49F08447.9040003@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F08447.9040003@linux.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 08:07:51AM -0700, Arjan van de Ven wrote:
> Andi Kleen wrote:
> >On Thu, Apr 23, 2009 at 04:38:59PM +0200, Johannes Weiner wrote:
> >>>+void warn_slowpath_null(const char *file, int line)
> >>>+{
> >>>+	warn_slowpath_fmt(file, line, (const char *) { 0 });
> >>>+}
> >>>+EXPORT_SYMBOL(warn_slowpath_null);
> >>I would WTF here without knowing the warning.  Can you add a comment?
> >>
> >>Otherwise, Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> >
> >Ok version with comment.
> 
> Makes sense if we plan to keep gcc 3.2 supported; if we plan to drop it 
> then we shouldn't bother.

It helps even for other compilers for code size, at least it shrunk Johannes' 
kernel by about 3k

> Acked-by: Arjan van de Ven <arjan@linux.intel.com>

Thanks.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
