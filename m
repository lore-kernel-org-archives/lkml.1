Return-Path: <linux-kernel-owner+w=401wt.eu-S933680AbXGKXUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680AbXGKXUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933486AbXGKXUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:20:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765906AbXGKXUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:20:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andreas Schwab <schwab@suse.de>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jason Wessel <jason.wessel@windriver.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] Pass -g to assembler under CONFIG_DEBUG_INFO
In-Reply-To: Andreas Schwab's message of  Thursday, 12 July 2007 01:15:23 +0200 <jeps2yjzw4.fsf@sykes.suse.de>
Emacs: because extension languages should come with the editor built in.
Message-Id: <20070711231929.579334D0555@magilla.localdomain>
Date: Wed, 11 Jul 2007 16:19:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > +AFLAGS		+= $(call as-option, -gdwarf)
> 
> The option is officially called -gdwarf-2, and -gdwarf2 is an alias for
> backward compatibility.  But -gdwarf is ambigous and will error out.

AFLAGS is actually passed to $(CC), not $(AS), and -gdwarf works there
(it's an unambiguous prefix of -gdwarf-2).


Thanks,
Roland
