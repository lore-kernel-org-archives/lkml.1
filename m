Return-Path: <linux-kernel-owner+w=401wt.eu-S1758420AbXFSQwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420AbXFSQwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 12:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbXFSQwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 12:52:30 -0400
Received: from mail.samba.org ([66.70.73.150]:60493 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbXFSQw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 12:52:29 -0400
Date: Tue, 19 Jun 2007 09:52:24 -0700
From: Jeremy Allison <jra@samba.org>
To: Theodore Tso <tytso@mit.edu>, Jeremy Allison <jra@samba.org>,
       "H. Peter Anvin" <hpa@zytor.com>, alan <alan@clueserver.org>,
       Bodo Eggert <7eggert@gmx.de>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
Message-ID: <20070619165224.GA19639@samba1>
Reply-To: Jeremy Allison <jra@samba.org>
References: <8wJal-3KA-1@gated-at.bofh.it> <8xm22-4Ql-1@gated-at.bofh.it> <8xq5G-32l-7@gated-at.bofh.it> <8xs7w-69W-21@gated-at.bofh.it> <E1I0OFQ-0001B9-7Z@be1.lrz> <Pine.LNX.4.64.0706181406250.25913@blackbox.fnordora.org> <4676F9A2.6010007@zytor.com> <20070618221021.GB2062@thunk.org> <20070618224815.GM1152@samba1> <20070619070507.GB9177@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619070507.GB9177@thunk.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 03:05:07AM -0400, Theodore Tso wrote:
> 
> There is a partial implementation lieing around somewhere, but there
> were a number of problems we ran into that were discussed in the
> slidedeck.  Basically, if the only program accessing the files
> containing forks was the Samba program calling forkdepot library, it
> worked fine.  But if there were other programs (or NFS servers) that
> were potentially deleting files, moving files around, the things fell
> apart fairly quickly.

I'd be happy with a Samba-only implementation for Appliance
vendors.

> What, even with Winfs delaying Microsoft Longwait by years before
> finally being flushed?  :-)

I'm not talking WinFS, I'm talking streams..... Streams are already
being used (mainly by malware writers of course - but hey, don't
you want full compatibility ? :-).

Jeremy.
