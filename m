Return-Path: <linux-kernel-owner+w=401wt.eu-S933234AbYEIQk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234AbYEIQk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 12:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755826AbYEIQkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 12:40:49 -0400
Received: from mail.fieldses.org ([66.93.2.214]:56958 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163AbYEIQks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 12:40:48 -0400
Date: Fri, 9 May 2008 12:40:44 -0400
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/9] file locking fixes + fuse nfs export support
Message-ID: <20080509164044.GA1907@fieldses.org>
References: <20080509124107.645600519@szeredi.hu> <20080509155040.GB798@fieldses.org> <E1JuUyz-0002GT-Hn@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JuUyz-0002GT-Hn@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 05:58:05PM +0200, Miklos Szeredi wrote:
> > A separate question--does the problem you reported with interrupted lock
> > requests still exist?
> 
> No, that bug seems to have gone away in 2.6.26-rc1.  Don't know how,
> since the 2.6.25 + nfs.git was still bad.

Yipes.

> Should I bisect it to see which patch solved it? ;)

That would be kinda amusing....

Well, and since I don't remember seeing anything that'd fix that I'd
like to make sure it isn't still lurking.

--b.
