Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbXJaCM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbXJaCM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 22:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbXJaCMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 22:12:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbXJaCMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 22:12:21 -0400
Date: Wed, 31 Oct 2007 02:11:23 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Vasily Averin <vvs@sw.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, devel@openvz.org, stable@kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Milan Broz <mbroz@redhat.com>,
       Neil Brown <neilb@suse.de>
Subject: Re: [dm-devel] Re: dm: bounce_pfn limit added
Message-ID: <20071031021123.GM10006@agk.fab.redhat.com>
Mail-Followup-To: Vasily Averin <vvs@sw.ru>,
	Andrew Morton <akpm@linux-foundation.org>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org, devel@openvz.org, stable@kernel.org,
	Jens Axboe <jens.axboe@oracle.com>, Milan Broz <mbroz@redhat.com>,
	Neil Brown <neilb@suse.de>
References: <47257E4B.4080904@sw.ru> <20071030131138.3ba59731.akpm@linux-foundation.org> <20071030232617.GJ10006@agk.fab.redhat.com> <20071031020133.GL10006@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071031020133.GL10006@agk.fab.redhat.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 02:01:33AM +0000, Alasdair G Kergon wrote:
> What if you swap in alternative dm targets, e.g. if it's linear,
> try multipath (round-robin, one path)?
  
And try using md instead of dm - does that also show the problem?
(md takes a similar stance to dm on this I believe.)

Alasdair
-- 
agk@redhat.com
