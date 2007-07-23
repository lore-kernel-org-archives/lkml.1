Return-Path: <linux-kernel-owner+w=401wt.eu-S1765519AbXGWIKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765519AbXGWIKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757053AbXGWIKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:10:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756087AbXGWIKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:10:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Move --build-id option
In-Reply-To: Sam Ravnborg's message of  Monday, 23 July 2007 08:42:35 +0200 <20070723064235.GA4129@uranus.ravnborg.org>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20070723080956.6080F4D058D@magilla.localdomain>
Date: Mon, 23 Jul 2007 01:09:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > -LDFLAGS_vmlinux += $(LDFLAGS_BUILD_ID)
> This needed to go otherwise you had to rely on all arch makefiles 
> used += for LDFLAGS_vmlinux assignments.

This line appears well after include $(srctree)/arch/$(ARCH)/Makefile.

> This will not work as LDFLAGS_BUILD_ID is not exported.

Oops!  I was overriding it in my testing, which exports it, so I didn't
notice that problem.

> Please make the change as outlined in earlier mail so we actually start
> using LDFALGS_MODULE as documented.

Patch coming.


Thanks,
Roland
