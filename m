Return-Path: <linux-kernel-owner+w=401wt.eu-S932079AbXFARyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbXFARyB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 13:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760351AbXFARxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 13:53:54 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:17744 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514AbXFARxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 13:53:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=BC14zQ1ymkYo/FqQX+aih9BbDIJ7WUrO1dRR+LbesCbkKy1Se8w/atFPZWQBfzuDaLrZVntboJxMlaC4F0nceVeMWj6kKsQUjhZF7dRPAxGumiIKKzgs+lxj0DMYjxij2YsBO3WBLqgdU+7X9wtADxSIAbsTwF7DlnOP75iKbRc=
Date: Fri, 1 Jun 2007 21:52:45 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] Fix possible leakage of blocks in UDF
Message-ID: <20070601175245.GD8398@cvg>
References: <20070524203653.GA7693@duck.suse.cz> <465DF0B4.2050203@sandeen.net> <465DF91F.3010201@sandeen.net> <20070531174201.GB8392@cvg> <465F09E7.7000300@sandeen.net> <20070601164926.GA8398@cvg> <20070601100425.89537dda.akpm@linux-foundation.org> <466054C1.3040100@sandeen.net> <20070601174806.GC8398@cvg> <46605CA6.1050509@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46605CA6.1050509@sandeen.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Eric Sandeen - Fri, Jun 01, 2007 at 12:51:34PM -0500]
| Cyrill Gorcunov wrote:
| >[Eric Sandeen - Fri, Jun 01, 2007 at 12:17:53PM -0500]
| >| Andrew Morton wrote:
| >| 
| >| >Recursive lock_kernel() is OK.
| >| 
| >| Oh, it is?  Clearly I am not well versed in the BKL... that's probably a 
| >| good thing.... :)
| >| 
| >| Ok, let me look into it further.  I changed lock_kernel to 
| >| udf_lock_kernel to complain & backtrace if we re-lock, and it always 
| >| immediately hung after that; I assumed that was it.  I'll investigate 
| >| further.
| >| 
| >| -Eric
| >| 
| >
| >Btw, Andrew is there any way to force kernel to use special UDF module
| >instead of compiled-in one? (Sorry for stupid question ;)
| 
| Not if it's  already built in (at least not with more hackery than it's 
| worth...) - just rebuild your kernel w/ udf as a module.
| 
| BTW my testcase before was bogus, that's not what's causing the lockup. 
|  I'll keep investigating now that I know what *not* to look for. ;-)
| 
| -Eric
| 

Thanks for answer

		Cyrill

