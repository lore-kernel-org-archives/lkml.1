Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbYAWSWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbYAWSWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 13:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbYAWSWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 13:22:34 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4466 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753353AbYAWSWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 13:22:32 -0500
Date: Wed, 23 Jan 2008 13:49:26 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hpa@zytor.com, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, util-linux-ng@vger.kernel.org,
       linuxram@us.ibm.com, viro@ftp.linux.org.uk, hch@infradead.org,
       a.p.zijlstra@chello.nl
Subject: Re: [RFC][PATCH] VFS: create /proc/<pid>/mountinfo
Message-ID: <20080123134926.GB4059@ucw.cz>
References: <E1JGBVq-0002Or-H1@pomaz-ex.szeredi.hu> <4792DF11.7040403@zytor.com> <E1JGVSG-0003mx-TS@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JGVSG-0003mx-TS@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-01-20 09:23:00, Miklos Szeredi wrote:
> > Miklos Szeredi wrote:
> > > - for mount ID's use IDA (from the IDR library) instead of a 32bit
> > >   counter, which could overflow
> > 
> > IDAs tend to get reused quickly, which can cause race conditions.  Any 
> > reason not to just use a 64-bit counter?
> 
> They tend to become hard to parse/compare for humans after a while.
> And all this is basically only for humans, so race conditions don't
> really matter.  Also a changed mount with a reused ID is easily
> identified by comparing the other fields.

Hmm, smart humans only compare last few digits if they don't care
about 100% reliability, and dumb software compares 64bits easily...
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
