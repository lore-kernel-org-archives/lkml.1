Return-Path: <linux-kernel-owner+w=401wt.eu-S933469AbXGaSPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933469AbXGaSPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 14:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761451AbXGaSPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 14:15:44 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4480 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056AbXGaSPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 14:15:43 -0400
Date: Tue, 31 Jul 2007 14:14:31 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Satyam Sharma <satyam@infradead.org>
Cc: akpm@linux-foundation.org, jeremy@goop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] argv_split: allow argv_split to handle NULL pointer in argcp parameter gracefully
Message-ID: <20070731181431.GE28333@hmsreliant.homelinux.net>
References: <20070731164608.GB28333@hmsreliant.homelinux.net> <alpine.LFD.0.999.0707312303490.28746@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707312303490.28746@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 11:06:52PM +0530, Satyam Sharma wrote:
> 
> 
> On Tue, 31 Jul 2007, Neil Horman wrote:
> 
> > As Jeremy and I had discussed in a previous thread, it would be nice if the
> > argv_split library function could gracefully handle a NULL pointer in the argcp
> > parameter, so as to allow functions using it that did not care about the value
> > of argc to not have to declare a useless variable.  This patch accomplishes
> > that.  Tested by me, with successful results.
> 
> The patch itself looks simple and straightforward enough, but having done
> this, now you'd also want to cleanup the use of the dummy variable in the
> callsites you mentioned above, correct? (Unless that's what Jeremy meant
> in his reply already)

yes, and as I've already replied, I have this patch ready.  however, I've got
some other work that I'm doing in one of the callsites, and since there are only
currently two sites, one of which already has some pending changesets in -mm,
I'm waiting for those to get some testing first. Once there are no
issues/requests with my current changesets, I'll be submitting a patch with the
cleanup of the callsites, along with some other changes.

regards
Neil

-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
