Return-Path: <linux-kernel-owner+w=401wt.eu-S1761940AbYEMVS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761940AbYEMVS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 17:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760191AbYEMVSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 17:18:04 -0400
Received: from mail.fieldses.org ([66.93.2.214]:39182 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760150AbYEMVSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 17:18:03 -0400
Date: Tue, 13 May 2008 17:17:56 -0400
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/9] file locking fixes + fuse nfs export support
Message-ID: <20080513211756.GA25349@fieldses.org>
References: <20080509124107.645600519@szeredi.hu> <20080509155040.GB798@fieldses.org> <E1JuUyz-0002GT-Hn@pomaz-ex.szeredi.hu> <20080509164044.GA1907@fieldses.org> <E1Jw1ge-0002eZ-Hk@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Jw1ge-0002eZ-Hk@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 11:05:28PM +0200, Miklos Szeredi wrote:
> > > > A separate question--does the problem you reported with interrupted lock
> > > > requests still exist?
> > > 
> > > No, that bug seems to have gone away in 2.6.26-rc1.  Don't know how,
> > > since the 2.6.25 + nfs.git was still bad.
> > 
> > Yipes.
> > 
> > > Should I bisect it to see which patch solved it? ;)
> > 
> > That would be kinda amusing....
> > 
> > Well, and since I don't remember seeing anything that'd fix that I'd
> > like to make sure it isn't still lurking.
> 
> Well, it was in the nfs-2.6 tree after all (commit 4d7c402).  I just

I think you must mean c4d7c402b788b73dc24f1e54a57f89d3dc5eb7bc, "NFS:
Remove the buggy lock-if-signalled case from do_setlk()"?

> mucked up testing the last time, probably because I didn't truly
> believe in this fix.

OK, that makes much more sense!  Thanks for the confirmation.

--b.
