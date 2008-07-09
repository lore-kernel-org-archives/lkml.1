Return-Path: <linux-kernel-owner+w=401wt.eu-S1757598AbYGIN6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbYGIN6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 09:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbYGIN6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 09:58:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:39486 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbYGIN6Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 09:58:16 -0400
Date: Wed, 9 Jul 2008 06:57:58 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Olaf =?UTF-8?B?RnLEhWN6eWs=?= <olaf@cbk.poznan.pl>
Cc: Theodore Tso <tytso@mit.edu>, Miklos Szeredi <miklos@szeredi.hu>,
       hch@infradead.org, pavel@suse.cz, t-sato@yk.jp.nec.com,
       akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, mtk.manpages@googlemail.com
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080709065758.4ac6b3c5@infradead.org>
In-Reply-To: <1215608360.20914.14.camel@venus.local.navi.pl>
References: <20080709010922.GE9957@mit.edu>
	<E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu>
	<20080709061621.GA5260@infradead.org>
	<E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu>
	<20080708234120.5072111f@infradead.org>
	<E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu>
	<20080708235502.1c52a586@infradead.org>
	<20080709071346.GS11558@disturbed>
	<20080709110900.GI9957@mit.edu>
	<20080709114958.GV11558@disturbed>
	<20080709122401.GK9957@mit.edu>
	<1215608360.20914.14.camel@venus.local.navi.pl>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jul 2008 14:59:20 +0200
Olaf Frączyk <olaf@cbk.poznan.pl> wrote:

> On Wed, 2008-07-09 at 08:24 -0400, Theodore Tso wrote:
> > On Wed, Jul 09, 2008 at 09:49:58PM +1000, Dave Chinner wrote:
> > > (e) none of the above.  The kernel compilation will appear to
> > > pause until the filesystem is unfrozen. No other visible effect
> > > should occur. It will get blocked in a write or filesystem
> > > transaction because the fs is frozen.
> > 
> > So if the process which froze the filesystem accidentally tries
> > writing to a log file (or database file containing the backup
> > information, or whatever) that happens to be on the filesystem that
> > is frozen, that process will get blocked and you end up in a
> > deadlock; did I get that right?
> Where do you see the deadlock?
> The process doesn't have a lock on filesystem or something. You can
> always unfreeze from another process.
> 

if it's one of your main filesystems... good luck starting a shell
without writing a single thing to disk... FAIL.
