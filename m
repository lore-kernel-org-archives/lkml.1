Return-Path: <linux-kernel-owner+w=401wt.eu-S1762383AbXFARtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762383AbXFARtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 13:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761687AbXFARtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 13:49:16 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:15872 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761674AbXFARtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 13:49:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=RXIlEHYVDdqhjxjsRsBNP2kQdTXox7SHnhm2ARfuxpTHBMiUlzmuaRNvhjba5LTwRGG6QU8brfw8BsN0zQpjKmPo9SrdM12JaW0ScpLFy4dzdqOQnfyQ7jRcr6ZT0YM93VAr4HqtClZcOush/COzv/+hc8YsFPReK1cWnKpEEBg=
Date: Fri, 1 Jun 2007 21:48:06 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] Fix possible leakage of blocks in UDF
Message-ID: <20070601174806.GC8398@cvg>
References: <20070524165935.GB19709@duck.suse.cz> <20070524170554.GC19709@duck.suse.cz> <20070524203653.GA7693@duck.suse.cz> <465DF0B4.2050203@sandeen.net> <465DF91F.3010201@sandeen.net> <20070531174201.GB8392@cvg> <465F09E7.7000300@sandeen.net> <20070601164926.GA8398@cvg> <20070601100425.89537dda.akpm@linux-foundation.org> <466054C1.3040100@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466054C1.3040100@sandeen.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Eric Sandeen - Fri, Jun 01, 2007 at 12:17:53PM -0500]
| Andrew Morton wrote:
| 
| >Recursive lock_kernel() is OK.
| 
| Oh, it is?  Clearly I am not well versed in the BKL... that's probably a 
| good thing.... :)
| 
| Ok, let me look into it further.  I changed lock_kernel to 
| udf_lock_kernel to complain & backtrace if we re-lock, and it always 
| immediately hung after that; I assumed that was it.  I'll investigate 
| further.
| 
| -Eric
| 

Btw, Andrew is there any way to force kernel to use special UDF module
instead of compiled-in one? (Sorry for stupid question ;)

		Cyrill

