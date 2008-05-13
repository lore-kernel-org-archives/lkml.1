Return-Path: <linux-kernel-owner+w=401wt.eu-S1761267AbYEMVFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761267AbYEMVFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 17:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758525AbYEMVFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 17:05:46 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:54029 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758519AbYEMVFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 17:05:45 -0400
To: bfields@fieldses.org
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080509164044.GA1907@fieldses.org> (bfields@fieldses.org)
Subject: Re: [patch 0/9] file locking fixes + fuse nfs export support
References: <20080509124107.645600519@szeredi.hu> <20080509155040.GB798@fieldses.org> <E1JuUyz-0002GT-Hn@pomaz-ex.szeredi.hu> <20080509164044.GA1907@fieldses.org>
Message-Id: <E1Jw1ge-0002eZ-Hk@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 13 May 2008 23:05:28 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > A separate question--does the problem you reported with interrupted lock
> > > requests still exist?
> > 
> > No, that bug seems to have gone away in 2.6.26-rc1.  Don't know how,
> > since the 2.6.25 + nfs.git was still bad.
> 
> Yipes.
> 
> > Should I bisect it to see which patch solved it? ;)
> 
> That would be kinda amusing....
> 
> Well, and since I don't remember seeing anything that'd fix that I'd
> like to make sure it isn't still lurking.

Well, it was in the nfs-2.6 tree after all (commit 4d7c402).  I just
mucked up testing the last time, probably because I didn't truly
believe in this fix.

Miklos
