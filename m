Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbYACMLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbYACMLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 07:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbYACMKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 07:10:53 -0500
Received: from neopsis.com ([213.239.204.14]:59020 "EHLO
	matterhorn.dbservice.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753394AbYACMKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 07:10:52 -0500
Message-ID: <477CD0B4.5000408@dbservice.com>
Date: Thu, 03 Jan 2008 13:10:28 +0100
From: Tomas Carnecky <tom@dbservice.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071216)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: =?ISO-8859-1?Q?J=F6rn_Engel_ <joern@logfs.org>, ?=@gmail.com,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [x86] kernel/audit.c cleanup according to checkpatch.pl
References: <20080103111925.GC8046@cvg> <20080103112957.GA14693@lazybastard.org> <20080103114642.GD8046@cvg>
In-Reply-To: <20080103114642.GD8046@cvg>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Neopsis-MailScanner-Information: Neopsis MailScanner using ClamAV and Spaassassin
X-Neopsis-MailScanner: Found to be clean
X-Neopsis-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-1.342, required 5, AWL -0.65, BAD_ENC_HEADER 1.81,
	BAYES_00 -2.60, RDNS_DYNAMIC 0.10)
X-MailScanner-From: tom@dbservice.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> [=?ISO-8859-1?Q?J=F6rn_Engel_ - Thu, Jan 03, 2008 at 12:29:57PM +0100]
> | On Thu, 3 January 2008 14:19:25 +0300, Cyrill Gorcunov wrote:
> | > @@ -232,7 +232,8 @@ void audit_log_lost(const char *message)
> | >  
> | >  	if (print) {
> | >  		printk(KERN_WARNING
> | > -		       "audit: audit_lost=%d audit_rate_limit=%d audit_backlog_limit=%d\n",
> | > +		       "audit: audit_lost=%d audit_rate_limit=%d "
> | > +		       "audit_backlog_limit=%d\n",
> | >  		       atomic_read(&audit_lost),
> | >  		       audit_rate_limit,
> | >  		       audit_backlog_limit);
> | 
> | This hunk is a bit questionable.  It can easily deceive a reader to
> | assume two seperate lines printed out and sometimes defeats grepping
> | for printk output to find the code generating the message.
> | 
> | Rest looks good to me.
> | 
> | Jörn
> | 
> | -- 
> | He that composes himself is wiser than he that composes a book.
> | -- B. Franklin
> | 
> 
> indeed.
> 
> here is updated one (with these part removed)

Instead of removing that part completely, why not print this:
"audit: lost=%d rate_limit=%d backlog_limit=%d\n"

In that line there were too many 'audit's IMHO, and if someone wants to 
grep 'audit_lost=' he still can, 'audit:.*lost=' or something like that..

tom
