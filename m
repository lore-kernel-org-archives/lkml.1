Return-Path: <linux-kernel-owner+w=401wt.eu-S936811AbXGLAhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936811AbXGLAhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936591AbXGLAhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:37:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935804AbXGLAhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:37:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] Add /sys/kernel/notes
In-Reply-To: Andrew Morton's message of  Wednesday, 11 July 2007 16:45:31 -0700 <20070711164531.aef1dcac.akpm@linux-foundation.org>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20070712003719.A803E4D0555@magilla.localdomain>
Date: Wed, 11 Jul 2007 17:37:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm curios to know what happens if nobody defines __start_notes and
> __end_notes.  We'll use the extern-attribute-weak thing, but those two
> locations won't even get instantiated in vmlinux, I think.
> 
> And the code relies upon the difference between two non-existent
> attribute-weak locations being zero.

The well-defined meaning of weak externs is that they resolve to zero if
undefined.  It relies on zero-zero being zero.  It relies on noone defining
one of __start_notes and __stop_notes but not both.


Thanks,
Roland
