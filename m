Return-Path: <linux-kernel-owner+w=401wt.eu-S1758273AbYDKBhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbYDKBhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 21:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbYDKBhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 21:37:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbYDKBhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 21:37:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] powerpc TLF_RESTORE_SIGMASK
In-Reply-To: Andrew Morton's message of  Wednesday, 9 April 2008 23:51:56 -0700 <20080409235156.33ee33f2.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20080403210842.6C88C26F98D@magilla.localdomain>
	<20080409235156.33ee33f2.akpm@linux-foundation.org>
X-Shopping-List: (1) Illustrious adhesive rain
   (2) Abrupt lip sofas
   (3) Olympic Ruinous battalions
Message-Id: <20080411013635.1F4B126F992@magilla.localdomain>
Date: Thu, 10 Apr 2008 18:36:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This crashes my powerpc mac g5.

It worked fine on mine.

> It happens after the boot, during the first login-over-ssh.

Mine did lots of stuff fine.

> This is with most of the rest of the -mm poopile applied.  i386 and x86_64
> seem OK.

I had only tested with Linus's tree plus the small handful of post-2.6.25
cleanup patches I've posted in the last few weeks.  To be precise it was
9597362d354f8655ece324b01d0c640a0e99c077 plus several of my cleanup patches
(that are probably all in -mm, but I'm not sure off hand).

I'd rebased my tree today to 783e391b7b5b273cd20856d8f6f4878da8ec31b3
anyway.  I just tried the new kernel with the sigmask cleanups and only 
a few other patches, and have no problems.

The details of your crash make it look pretty unrelated to this code.
Off hand I would guess that it's some other bug from other -mm patches
that just happens only to bite you on powerpc.  If the crash is not
intermittent and you bisected it to this one change, then I am at a
loss to see what might be happening.  I'd have to leave it to Paul et
al to figure out if there is some strange powerpc juju going on.


Thanks,
Roland
