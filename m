Return-Path: <linux-kernel-owner+w=401wt.eu-S1757071AbXEWMfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071AbXEWMfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 08:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbXEWMeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 08:34:50 -0400
Received: from pat.uio.no ([129.240.10.15]:56268 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335AbXEWMet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 08:34:49 -0400
Subject: Re: [RFC PATCH] file as directory
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <20070523073658.GO4095@ftp.linux.org.uk>
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu>
	 <20070522221045.GH4095@ftp.linux.org.uk>
	 <E1HqkS4-00017K-00@dorka.pomaz.szeredi.hu>
	 <20070523070306.GM4095@ftp.linux.org.uk>
	 <E1Hql7t-0001EQ-00@dorka.pomaz.szeredi.hu>
	 <20070523073658.GO4095@ftp.linux.org.uk>
Content-Type: text/plain
Date: Wed, 23 May 2007 08:34:42 -0400
Message-Id: <1179923682.6480.18.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.120)
X-UiO-Scanned: 71BF551EA51959C4410FCC6DF789E34B960ADBA8
X-UiO-Ratelimit-Test: Ratelimit
X-UiO-SPAM-Test: UIO-RATELIMIT remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 1291 total 1905561 max/h 8345 blacklist 0 greylist 0 ratelimit 1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-23 at 08:36 +0100, Al Viro wrote:
> On Wed, May 23, 2007 at 09:19:17AM +0200, Miklos Szeredi wrote:
> > > Eh...  Arbitrary limitations are fun, aren't they?
> > 
> > But these mounts _are_ special.  There is really no point in moving or
> > pivoting them.
> 
> pivoting - probably true, moving... why not?

Moving would be an implementation artefact that doesn't really
correspond to any useful operation on the filesyst

AFAIK, most filesystems that have implemented subfiles (excepting
Reiser4 of course) do not allow you to rename or move the subfile
directory or its contents from one parent file to another.

Trond

