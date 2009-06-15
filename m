Return-Path: <linux-kernel-owner+w=401wt.eu-S1754289AbZFOCow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbZFOCow (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 22:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbZFOCoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 22:44:44 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:26928 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbZFOCoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 22:44:44 -0400
X-IronPort-AV: E=Sophos;i="4.42,220,1243814400"; 
   d="scan'208";a="199844917"
From: Roland Dreier <rdreier@cisco.com>
To: Avi Kivity <avi@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       benh@kernel.crashing.org, akpm@linux-foundation.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] lib: Provide generic atomic64_t implementation
References: <18995.20685.227683.561827@cargo.ozlabs.ibm.com>
	<alpine.LFD.2.01.0906131312470.3237@localhost.localdomain>
	<alpine.LFD.2.01.0906131323270.3237@localhost.localdomain>
	<4A34E4A5.3040306@redhat.com>
	<18996.60235.178618.531664@cargo.ozlabs.ibm.com>
	<4A34F564.2010500@redhat.com>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 14 Jun 2009 19:44:45 -0700
In-Reply-To: <4A34F564.2010500@redhat.com> (Avi Kivity's message of "Sun, 14
	Jun 2009 16:04:36 +0300")
Message-ID: <ada4ouixlk2.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Jun 2009 02:44:46.0427 (UTC) FILETIME=[3E950AB0:01C9ED63]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > The new Nehalems provide 8 logical threads in a single socket.  All
 > those threads share a cache, and they have cmpxchg8b anyway, so this
 > won't matter.

FWIW, Nehalem EX actually goes to 8 cores/16 threads per socket.  But
worrying about 32-bit performance on Nehalem is a little silly -- this
simplest solution is simply to run a 64-bit kernel.

 - R.
