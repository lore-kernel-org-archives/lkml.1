Return-Path: <linux-kernel-owner+w=401wt.eu-S932643AbXJQWHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643AbXJQWHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 18:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbXJQWGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 18:06:53 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:21723 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103AbXJQWGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 18:06:52 -0400
X-IronPort-AV: E=Sophos;i="4.21,291,1188802800"; 
   d="scan'208";a="536691226"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND] file operations: release can race with read/write?
X-Message-Flag: Warning: May contain useful information
References: <adave96ki0x.fsf@cisco.com> <adaodexh9uz.fsf@cisco.com>
	<20071017121656.484646a5.akpm@linux-foundation.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 17 Oct 2007 15:06:49 -0700
In-Reply-To: <20071017121656.484646a5.akpm@linux-foundation.org> (Andrew Morton's message of "Wed, 17 Oct 2007 12:16:56 -0700")
Message-ID: <adafy09gzuu.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Oct 2007 22:06:50.0254 (UTC) FILETIME=[047A7AE0:01C8110A]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > After pthread_create()'s clone() you should have files->count==2, so
 > fget_light() will do the full atomic_inc_not_zero() thing?

Indeed.  Thanks for the clue.

I guess the search for the bug goes on.  (I only have a picture of the
tail end of one oops message to work with so far, hence the wild
speculation).

Thanks,
  Roland
