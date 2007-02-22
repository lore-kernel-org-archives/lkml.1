Return-Path: <linux-kernel-owner+w=401wt.eu-S1751889AbXBVVEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbXBVVEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 16:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbXBVVEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 16:04:35 -0500
Received: from pat.uio.no ([129.240.10.15]:34095 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbXBVVEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 16:04:34 -0500
Subject: Re: [PATCH] update ctime and mtime for mmaped write
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: staubach@redhat.com, akpm@linux-foundation.org, hugh@veritas.com,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1HKKrL-0006k6-00@dorka.pomaz.szeredi.hu>
References: <E1HJvdA-0003Nj-00@dorka.pomaz.szeredi.hu>
	 <20070221202615.a0a167f4.akpm@linux-foundation.org>
	 <E1HK8hU-0005Mq-00@dorka.pomaz.szeredi.hu> <45DDD55F.4060106@redhat.com>
	 <E1HKIN1-0006RX-00@dorka.pomaz.szeredi.hu> <45DDF9C1.4090003@redhat.com>
	 <E1HKKrL-0006k6-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 16:04:13 -0500
Message-Id: <1172178253.6382.12.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.91 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: 57AD9C5D5C402079CA8A28C01644BDCD2B745C3D
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 77 total 29363 max/h 2155 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-22 at 21:48 +0100, Miklos Szeredi wrote:
> > This still does not address the situation where a file is 'permanently'
> > mmap'd, does it?
> 
> So?  If application doesn't do msync, then the file times won't be
> updated.  That's allowed by the standard, and so portable applications
> will have to call msync.

It is allowed, but it is clearly not useful behaviour. Nowhere is it set
in stone that we should be implementing just the minimum allowed.

Trond

