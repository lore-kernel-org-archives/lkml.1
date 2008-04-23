Return-Path: <linux-kernel-owner+w=401wt.eu-S1756603AbYDWP5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbYDWP5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 11:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbYDWP50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 11:57:26 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:55036 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbYDWP50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 11:57:26 -0400
X-IronPort-AV: E=Sophos;i="4.25,700,1199692800"; 
   d="scan'208";a="23111764"
From: Roland Dreier <rdreier@cisco.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: Pull request for semaphore include changes
References: <20080419184029.GO20637@parisc-linux.org>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 23 Apr 2008 08:57:24 -0700
In-Reply-To: <20080419184029.GO20637@parisc-linux.org> (Matthew Wilcox's
	message of "Sat, 19 Apr 2008 12:40:30 -0600")
Message-ID: <adawsmobm3f.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Apr 2008 15:57:24.0786 (UTC) FILETIME=[B8E73920:01C8A55A]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 >  drivers/infiniband/core/user_mad.c            |    2 +-

Let me say up front I have no problem with this change, which moved from
<asm/semaphore.h> to <linux/semaphore.h>.  So take this email as an
honest question and not any form of complaint or criticism.  But looking
at that user_mad.c file in particular, I don't see any use of anything
that looks like it would come from semaphore.h.

So I'm wondering why you didn't just delete the inclusion, as you did in
other places?  I can merge a follow-up that does that cleanup (which
builds and works fine on my usual architectures) but I want to avoid
breaking avr32 allyesconfig or something like that.

(Commit 2fe7e6f7 "IB/umad: Simplify and fix locking" changed the locking
scheme, so maybe you looked at an older file)

Thanks,
  Roland
