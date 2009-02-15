Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbZBPC5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbZBPC5a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 21:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756284AbZBPC4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 21:56:48 -0500
Received: from thunk.org ([69.25.196.29]:37216 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756210AbZBPC4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 21:56:47 -0500
Date: Sun, 15 Feb 2009 17:54:27 -0500
From: Theodore Tso <tytso@mit.edu>
To: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>,
       Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, fernando@kic.ac.jp,
       Ric Wheeler <rwheeler@redhat.com>
Subject: Re: vfs: Add MS_FLUSHONFSYNC mount flag
Message-ID: <20090215225427.GH10706@mini-me.lan>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao <fernando@oss.ntt.co.jp>,
	Christoph Hellwig <hch@infradead.org>,
	Jeff Garzik <jeff@garzik.org>, Eric Sandeen <sandeen@redhat.com>,
	Jan Kara <jack@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Pavel Machek <pavel@suse.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>, fernando@kic.ac.jp,
	Ric Wheeler <rwheeler@redhat.com>
References: <1232186449.4831.29.camel@sebastian.kern.oss.ntt.co.jp> <20090119120349.GA10193@duck.suse.cz> <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp> <20090128095518.GA16554@duck.suse.cz> <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp> <1234434970.15433.4.camel@sebastian.kern.oss.ntt.co.jp> <499458C1.90105@redhat.com> <49945C90.3010104@garzik.org> <20090214153626.GA3973@infradead.org> <1234682606.19783.222.camel@sebastian.kern.oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1234682606.19783.222.camel@sebastian.kern.oss.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 15, 2009 at 04:23:26PM +0900, Fernando Luis Vázquez Cao wrote:
> You mentioned "we should integrate this with the barrier settings". Do
> you imply we should make it a per-device tunable too? Should we keep the
> barrier-related mount options some filesystems provide?
> 

Making barriers to be a per-device tunable makes sense.  The only
reason why we kept it as a mount option in ext4 is for benchmarking
purposes, and in ext3, because the filesystem predated the barrier
code, and there was a desire to be able to benchmark with and without
the old behavior --- and because akpm is still worried about the
performance hit of the barrier code, so he's been resistant about
change the default for ext3.

       	   				- Ted

