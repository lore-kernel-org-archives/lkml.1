Return-Path: <linux-kernel-owner+w=401wt.eu-S1757917AbXFSHG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbXFSHG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 03:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbXFSHGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 03:06:19 -0400
Received: from THUNK.ORG ([69.25.196.29]:49805 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332AbXFSHGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 03:06:18 -0400
Date: Tue, 19 Jun 2007 03:05:07 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jeremy Allison <jra@samba.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, alan <alan@clueserver.org>,
       Bodo Eggert <7eggert@gmx.de>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
Message-ID: <20070619070507.GB9177@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jeremy Allison <jra@samba.org>, "H. Peter Anvin" <hpa@zytor.com>,
	alan <alan@clueserver.org>, Bodo Eggert <7eggert@gmx.de>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	Jack Stone <jack@hawkeye.stone.uk.eu.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	akpm@linux-foundation.org, viro@zeniv.linux.org.uk
References: <8wsW4-3UY-3@gated-at.bofh.it> <8wJal-3KA-1@gated-at.bofh.it> <8xm22-4Ql-1@gated-at.bofh.it> <8xq5G-32l-7@gated-at.bofh.it> <8xs7w-69W-21@gated-at.bofh.it> <E1I0OFQ-0001B9-7Z@be1.lrz> <Pine.LNX.4.64.0706181406250.25913@blackbox.fnordora.org> <4676F9A2.6010007@zytor.com> <20070618221021.GB2062@thunk.org> <20070618224815.GM1152@samba1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618224815.GM1152@samba1>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 03:48:15PM -0700, Jeremy Allison wrote:
> Did you ever code up forkdepot ? Just wondering ?

There is a partial implementation lieing around somewhere, but there
were a number of problems we ran into that were discussed in the
slidedeck.  Basically, if the only program accessing the files
containing forks was the Samba program calling forkdepot library, it
worked fine.  But if there were other programs (or NFS servers) that
were potentially deleting files, moving files around, the things fell
apart fairly quickly.

> Just because I now agree with you that streams are
> a bad idea doesn't mean the pressure to support them
> in some way in Samba has gone away :-).

What, even with Winfs delaying Microsoft Longwait by years before
finally being flushed?  :-)

						- Ted

