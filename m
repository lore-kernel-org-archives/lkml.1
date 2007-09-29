Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbXI2KIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbXI2KIw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 06:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbXI2KIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 06:08:46 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:39162 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbXI2KIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 06:08:45 -0400
Date: Sat, 29 Sep 2007 12:10:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, apw@shadowen.org,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 3/3] New script to check coding-style compliance on multiple regular files
Message-ID: <20070929101012.GA12555@uranus.ravnborg.org>
References: <11910151223214-git-send-email-ezk@cs.sunysb.edu> <1191015124866-git-send-email-ezk@cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191015124866-git-send-email-ezk@cs.sunysb.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Erez.

On Fri, Sep 28, 2007 at 05:32:02PM -0400, Erez Zadok wrote:
> The script calls checkpatch.pl on each file, and formats any error messages
> to comply with standard compiler error messages:
> 
> 	file_name:line_number:error_message
> 
> This is particularly useful when run from within a text editor which can
> parse these error messages and show the user a buffer with the file in
> question, placing the cursor on the offending line (e.g., Emacs's "M-x
> next-error" command, bound by default to C-x `).

The concept is wrong here. If we want checkpatch to generate
message in standard gcc format then we should fix checkpatch and
not add a wrapper script around it.

For checkpatch related patches please forward them to the checkpatch
maintainers.

>From MAINTAINERS:

CHECKPATCH
P:      Andy Whitcroft
M:      apw@shadowen.org
P:      Randy Dunlap
M:      rdunlap@xenotime.net
P:      Joel Schopp
M:      jschopp@austin.ibm.com
S:      Supported



	Sam
