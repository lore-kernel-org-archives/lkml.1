Return-Path: <linux-kernel-owner+w=401wt.eu-S1760918AbXEaQud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760918AbXEaQud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 12:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758244AbXEaQuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 12:50:05 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:43867 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757621AbXEaQuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 12:50:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=CNntwSktckmDVUwXwjVtVanViP+lwaj+qsfvyAIQl5qmvhzrARA5/+Nag1v+XXnvj7bXgKTdrIgGOxApRFvyNSq0+lq9Hzmobw8Dv+rHrz2+XfZevyAYz9sMXutYPgo8ogA86vtDQMN+baCCzODFfaeCnBtNLsjgzwZTVMCqBjY=
Date: Thu, 31 May 2007 20:48:42 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Fix possible leakage of blocks in UDF
Message-ID: <20070531164842.GA8392@cvg>
References: <20070524165935.GB19709@duck.suse.cz> <20070524170554.GC19709@duck.suse.cz> <20070524203653.GA7693@duck.suse.cz> <465DF0B4.2050203@sandeen.net> <465DF91F.3010201@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465DF91F.3010201@sandeen.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Eric Sandeen - Wed, May 30, 2007 at 05:22:23PM -0500]
| Eric Sandeen wrote:
| 
| > Jan, something seems busted here.  I'm getting lockups when testing udf
| > on a single cpu with this last patch in place...
| > 
| > I think it's the BKL stumbling on itself.
| 
| To demonstrate, try this:
| 
| # BIGFILENAME=`seq -s '' 1 1000`
| # ln -s $BIGFILENAME foo
| 
| instant deadlock :(
| 
| -Eric
| 

Hi, thanks for error report. I'm checking this tommorow I guess
(too busy now)

		Cyrill

