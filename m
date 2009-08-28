Return-Path: <linux-kernel-owner+w=401wt.eu-S1751188AbZH1XGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751188AbZH1XGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 19:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbZH1XGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 19:06:31 -0400
Received: from mail2.shareable.org ([80.68.89.115]:37318 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbZH1XGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 19:06:30 -0400
Date: Sat, 29 Aug 2009 00:06:23 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ulrich Drepper <drepper@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: adding proper O_SYNC/O_DSYNC, was Re: O_DIRECT and barriers
Message-ID: <20090828230623.GD8036@shareable.org>
References: <20090821135403.GA6208@shareable.org> <20090821142635.GB30617@infradead.org> <20090821152459.GC6929@shareable.org> <20090821174525.GA28861@infradead.org> <20090822005006.GA22530@shareable.org> <20090824023422.GA775@infradead.org> <20090827143459.GB31453@shareable.org> <20090827171044.GA5427@infradead.org> <4A96C14C.8040105@redhat.com> <20090828154647.GA15808@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090828154647.GA15808@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
>  - given that our current O_SYNC really is and always has been actuall
>    Posix O_DSYNC

Are you sure about this?

>From http://www-01.ibm.com/support/docview.wss?uid=isg1IZ01704 :

    Error description

       LINUX O_DIRECT/O_SYNC TAKES TOO MANY IOS

    Problem summary

       On AIX, the O_SYNC and O_DSYNC are different values and
       performance improvement are available because the inode does
       not need to be flushed for mtime changes only.
       On Linux the flags are the same, so performance is lost.
       when databases open files with O_DIRECT and O_SYNC.

-- Jamie
