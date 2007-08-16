Return-Path: <linux-kernel-owner+w=401wt.eu-S1765641AbXHPWbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765641AbXHPWbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 18:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760546AbXHPWbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 18:31:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757476AbXHPWbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 18:31:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Adrian Bunk <bunk@stusta.de>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Andreas Schwab <schwab@suse.de>
Subject: Re: [-mm patch] AFLAGS: fix the -g setting
In-Reply-To: Adrian Bunk's message of  Friday, 17 August 2007 00:16:36 +0200 <20070816221636.GA3786@stusta.de>
X-Windows: the defacto substandard.
Message-Id: <20070816223023.C27004D0461@magilla.localdomain>
Date: Thu, 16 Aug 2007 15:30:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Indeed, Andreas was taling about the as options.  
But AFLAGS is in fact passed to $(CC).
Honestly, I don't think there is any reason not just to use -g.
If something else should be passed to the assembler, the compiler 
can be the one to worry about that.


Thanks,
Roland
