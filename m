Return-Path: <linux-kernel-owner+w=401wt.eu-S1756339AbYACLf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbYACLf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 06:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbYACLfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 06:35:48 -0500
Received: from lazybastard.de ([212.112.238.170]:49562 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbYACLfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 06:35:47 -0500
Date: Thu, 3 Jan 2008 12:29:57 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [x86] kernel/audit.c cleanup according to checkpatch.pl
Message-ID: <20080103112957.GA14693@lazybastard.org>
References: <20080103111925.GC8046@cvg>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080103111925.GC8046@cvg>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 January 2008 14:19:25 +0300, Cyrill Gorcunov wrote:
> @@ -232,7 +232,8 @@ void audit_log_lost(const char *message)
>  
>  	if (print) {
>  		printk(KERN_WARNING
> -		       "audit: audit_lost=%d audit_rate_limit=%d audit_backlog_limit=%d\n",
> +		       "audit: audit_lost=%d audit_rate_limit=%d "
> +		       "audit_backlog_limit=%d\n",
>  		       atomic_read(&audit_lost),
>  		       audit_rate_limit,
>  		       audit_backlog_limit);

This hunk is a bit questionable.  It can easily deceive a reader to
assume two seperate lines printed out and sometimes defeats grepping
for printk output to find the code generating the message.

Rest looks good to me.

Jörn

-- 
He that composes himself is wiser than he that composes a book.
-- B. Franklin
