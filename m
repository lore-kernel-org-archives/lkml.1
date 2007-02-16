Return-Path: <linux-kernel-owner+w=401wt.eu-S1945963AbXBPQHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945963AbXBPQHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 11:07:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945965AbXBPQHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 11:07:08 -0500
Received: from thunk.org ([69.25.196.29]:40461 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945963AbXBPQHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 11:07:06 -0500
Date: Fri, 16 Feb 2007 09:50:33 -0500
From: Theodore Tso <tytso@mit.edu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@osdl.org>
Subject: Re: [PATCH] update Doc/oops-tracing.txt for TAINT_USER
Message-ID: <20070216145033.GA25957@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	lkml <linux-kernel@vger.kernel.org>, akpm <akpm@osdl.org>
References: <20070215170414.56e6193b.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070215170414.56e6193b.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 05:04:14PM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Add TAINT_USER description to Tainted flags in oops-tracing.txt.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  Documentation/oops-tracing.txt |    3 +++
>  1 file changed, 3 insertions(+)
> 
> --- linux-2.6.20-git9.orig/Documentation/oops-tracing.txt
> +++ linux-2.6.20-git9/Documentation/oops-tracing.txt
> @@ -234,6 +234,9 @@ characters, each representing a particul
>    6: 'B' if a page-release function has found a bad page reference or
>       some unexpected page flags.
>  
> +  7: 'U' if a user specifically requested that the Tainted flag be set,
> +     ' ' otherwise.
> +

I suggest you change this to read "if a user or user application".

Otherwise,

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>


BTW, most often it will be a specific user application.  The initial
intended use case was a Java Virtual Machine, that will set the
Tainted flag as a hint to support personnel that Java program it was
running was doing something really evil and non-portable (direct
access to physical memory) which unfortunately the RTSJ compliance
test requires us to support .  Thank you very much, Sun....

"Java: Write once, run screaming".  :-)

						- Ted
