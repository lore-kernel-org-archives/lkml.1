Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbZEZBpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbZEZBpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 21:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbZEZBp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 21:45:26 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:9193 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbZEZBpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 21:45:25 -0400
X-IronPort-AV: E=Sophos;i="4.41,247,1241395200"; 
   d="scan'208";a="310524172"
From: Roland Dreier <rdreier@cisco.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 03/13] scsi: unify allocation of scsi command and sense buffer
References: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
	<1243236668-3398-6-git-send-email-jens.axboe@oracle.com>
	<4A1A64A1.2050409@panasas.com>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 25 May 2009 18:45:25 -0700
In-Reply-To: <4A1A64A1.2050409@panasas.com> (Boaz Harrosh's message of "Mon,
	25 May 2009 12:28:01 +0300")
Message-ID: <aday6sk8wne.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 May 2009 01:45:26.0377 (UTC) FILETIME=[A45D8590:01C9DDA3]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Ideally there should be a MACRO that is defined to WORD_SIZE on cache-coherent
 > ARCHs and to SMP_CACHE_BYTES on none-cache-coherent systems and use that size
 > at the __align() attribute. (So only stupid ARCHES get hurt)

this seems to come up repeatedly -- I had a proposal a _long_ time ago
that never quite got merged, cf http://lwn.net/Articles/2265/ and
http://lwn.net/Articles/2269/ -- from 2002 (!?).  The idea is to go a
step further and create a __dma_buffer annotation for structure members.

Maybe I should resurrect that work one more time?

 - R.
