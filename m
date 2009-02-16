Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbZBPHrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbZBPHrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 02:47:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbZBPHr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 02:47:26 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:43783 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbZBPHrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 02:47:25 -0500
Subject: Re: vfs: Add MS_FLUSHONFSYNC mount flag
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Theodore Tso <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>,
       Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, fernando@kic.ac.jp,
       Ric Wheeler <rwheeler@redhat.com>, linux-fsdevel@vger.kernel.org
In-Reply-To: <20090215225427.GH10706@mini-me.lan>
References: <1232186449.4831.29.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090119120349.GA10193@duck.suse.cz>
	 <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090128095518.GA16554@duck.suse.cz>
	 <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp>
	 <1234434970.15433.4.camel@sebastian.kern.oss.ntt.co.jp>
	 <499458C1.90105@redhat.com> <49945C90.3010104@garzik.org>
	 <20090214153626.GA3973@infradead.org>
	 <1234682606.19783.222.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090215225427.GH10706@mini-me.lan>
Content-Type: text/plain; charset=UTF-8
Organization: NTT Open Source Software Center
Date: Mon, 16 Feb 2009 16:47:24 +0900
Message-Id: <1234770444.32677.60.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-02-15 at 17:54 -0500, Theodore Tso wrote:
> On Sun, Feb 15, 2009 at 04:23:26PM +0900, Fernando Luis Vázquez Cao wrote:
> > You mentioned "we should integrate this with the barrier settings". Do
> > you imply we should make it a per-device tunable too? Should we keep the
> > barrier-related mount options some filesystems provide?
> > 
> 
> Making barriers to be a per-device tunable makes sense.  The only
> reason why we kept it as a mount option in ext4 is for benchmarking
> purposes, and in ext3, because the filesystem predated the barrier
> code, and there was a desire to be able to benchmark with and without
> the old behavior --- and because akpm is still worried about the
> performance hit of the barrier code, so he's been resistant about
> change the default for ext3.

Ok, I'll turn both barriers and flushonfsync into a sysfs-exported
per-device knob and see how it turns out.

By the way, should we also add/keep a mount option for "benchmarking
purposes"?. I guess that once we get the per-device tunable we probable
do not need it anymore.

Regards,

Fernando

