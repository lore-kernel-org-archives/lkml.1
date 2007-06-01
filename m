Return-Path: <linux-kernel-owner+w=401wt.eu-S1762297AbXFARvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762297AbXFARvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 13:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758881AbXFARvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 13:51:36 -0400
Received: from sandeen.net ([209.173.210.139]:12461 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755514AbXFARvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 13:51:36 -0400
Message-ID: <46605CA6.1050509@sandeen.net>
Date: Fri, 01 Jun 2007 12:51:34 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] Fix possible leakage of blocks in UDF
References: <20070524165935.GB19709@duck.suse.cz> <20070524170554.GC19709@duck.suse.cz> <20070524203653.GA7693@duck.suse.cz> <465DF0B4.2050203@sandeen.net> <465DF91F.3010201@sandeen.net> <20070531174201.GB8392@cvg> <465F09E7.7000300@sandeen.net> <20070601164926.GA8398@cvg> <20070601100425.89537dda.akpm@linux-foundation.org> <466054C1.3040100@sandeen.net> <20070601174806.GC8398@cvg>
In-Reply-To: <20070601174806.GC8398@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> [Eric Sandeen - Fri, Jun 01, 2007 at 12:17:53PM -0500]
> | Andrew Morton wrote:
> | 
> | >Recursive lock_kernel() is OK.
> | 
> | Oh, it is?  Clearly I am not well versed in the BKL... that's probably a 
> | good thing.... :)
> | 
> | Ok, let me look into it further.  I changed lock_kernel to 
> | udf_lock_kernel to complain & backtrace if we re-lock, and it always 
> | immediately hung after that; I assumed that was it.  I'll investigate 
> | further.
> | 
> | -Eric
> | 
> 
> Btw, Andrew is there any way to force kernel to use special UDF module
> instead of compiled-in one? (Sorry for stupid question ;)

Not if it's  already built in (at least not with more hackery than it's 
worth...) - just rebuild your kernel w/ udf as a module.

BTW my testcase before was bogus, that's not what's causing the lockup. 
  I'll keep investigating now that I know what *not* to look for. ;-)

-Eric
