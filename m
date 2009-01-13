Return-Path: <linux-kernel-owner+w=401wt.eu-S1760948AbZAMOqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760948AbZAMOqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 09:46:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbZAMOqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 09:46:46 -0500
Received: from thunk.org ([69.25.196.29]:38788 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928AbZAMOqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 09:46:46 -0500
Date: Tue, 13 Jan 2009 09:46:40 -0500
From: Theodore Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: ext2 + -osync: not as easy as it seems
Message-ID: <20090113144640.GE17664@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>
References: <20090113131418.GD30352@atrey.karlin.mff.cuni.cz> <20090113134503.41318144@lxorguk.ukuu.org.uk> <20090113140347.GD17664@mit.edu> <20090113143011.GB10064@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113143011.GB10064@duck.suse.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 03:30:12PM +0100, Jan Kara wrote:
> 
>   But it's not the whole story. Strictly speaking we should also call
> blkdev_issue_flush() whenever we write things because of O_SYNC or
> O_DIRSYNC flags. My patch does also that (it's based on the previous ext2
> patch I've sent a while before).

Looks good to me.

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
