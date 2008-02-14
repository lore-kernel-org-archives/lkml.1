Return-Path: <linux-kernel-owner+w=401wt.eu-S1765689AbYBNUDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765689AbYBNUDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:03:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765075AbYBNUDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:03:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765004AbYBNUDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:03:04 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
X-Fcc: ~/Mail/linus
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] samples: build fix
In-Reply-To: Sam Ravnborg's message of  Thursday, 14 February 2008 20:46:33 +0100 <20080214194633.GA21894@uranus.ravnborg.org>
References: <20080214034541.EF1BD270192@magilla.localdomain>
	<20080214132752.GA27478@Krystal>
	<20080214194633.GA21894@uranus.ravnborg.org>
Emacs: there's a reason it comes with a built-in psychotherapist.
Message-Id: <20080214200257.42815270195@magilla.localdomain>
Date: Thu, 14 Feb 2008 12:02:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't have any axe to grind here, I just could not figure out how to get
the samples/ modules built (without resorting to make M=.../samples/foo and
clobbering my source directory).  If there is another plan, point me to its
documentation.  I can't see the point of the Kconfig option for samples at all.
What does it do?

Because they are only ever modules, the samples are never built in.  I
honestly don't see why the modules shouldn't be installed like any others.
People who are really going to install the kernel for production are not
going to set this Kconfig option.


Thanks,
Roland
