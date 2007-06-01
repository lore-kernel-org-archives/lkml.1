Return-Path: <linux-kernel-owner+w=401wt.eu-S1762501AbXFARSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762501AbXFARSE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 13:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761059AbXFARRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 13:17:55 -0400
Received: from sandeen.net ([209.173.210.139]:12244 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760990AbXFARRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 13:17:55 -0400
Message-ID: <466054C1.3040100@sandeen.net>
Date: Fri, 01 Jun 2007 12:17:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] Fix possible leakage of blocks in UDF
References: <20070524165935.GB19709@duck.suse.cz>	<20070524170554.GC19709@duck.suse.cz>	<20070524203653.GA7693@duck.suse.cz>	<465DF0B4.2050203@sandeen.net>	<465DF91F.3010201@sandeen.net>	<20070531174201.GB8392@cvg>	<465F09E7.7000300@sandeen.net>	<20070601164926.GA8398@cvg> <20070601100425.89537dda.akpm@linux-foundation.org>
In-Reply-To: <20070601100425.89537dda.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> Recursive lock_kernel() is OK.

Oh, it is?  Clearly I am not well versed in the BKL... that's probably a 
good thing.... :)

Ok, let me look into it further.  I changed lock_kernel to 
udf_lock_kernel to complain & backtrace if we re-lock, and it always 
immediately hung after that; I assumed that was it.  I'll investigate 
further.

-Eric
