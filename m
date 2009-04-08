Return-Path: <linux-kernel-owner+w=401wt.eu-S934427AbZDHRdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934427AbZDHRdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934412AbZDHRck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 13:32:40 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:42089 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933604AbZDHRcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 13:32:39 -0400
X-IronPort-AV: E=Sophos;i="4.39,345,1235952000"; 
   d="scan'208";a="151695606"
From: Roland Dreier <rdreier@cisco.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, felixb@sgi.com,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: [PATCH 4/6] xfs: use memdup_user()
References: <49DC4CC0.9050805@cn.fujitsu.com>
	<49DC4D54.3020001@cn.fujitsu.com>
	<20090408132254.GA5957@infradead.org>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 08 Apr 2009 10:31:25 -0700
In-Reply-To: <20090408132254.GA5957@infradead.org> (Christoph Hellwig's
	message of "Wed, 8 Apr 2009 09:22:54 -0400")
Message-ID: <adabpr76oia.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Apr 2009 17:31:25.0424 (UTC) FILETIME=[D790C700:01C9B86F]
Authentication-Results: syd-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/syddkim1002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > wouldn't NULL be a better error return for this kind of interface,
 > matching kmalloc?

I guess returning an error code from memdup_user() lets callers
distinguish between ENOMEM and EFAULT.  Not sure if that's important or
not but there probably are at least some sites that care.

 - R.
