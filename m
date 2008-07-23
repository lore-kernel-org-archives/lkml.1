Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238AbYGWU2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbYGWU2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 16:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbYGWU20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 16:28:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755269AbYGWU2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 16:28:25 -0400
Date: Wed, 23 Jul 2008 13:24:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <greg@kroah.com>
cc: pHilipp Zabel <philipp.zabel@gmail.com>, Greg KH <gregkh@suse.de>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       Randy Dunlap <rdunlap@xenotime.net>, Willy Tarreau <w@1wt.eu>,
       Chuck Wolber <chuckw@quantumlinux.com>, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       Jake Edge <jake@lwn.net>, Michael Krufky <mkrufky@linuxtv.org>,
       stable@kernel.org, Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [stable] [patch 44/47] pxamci: fix byte aligned DMA transfers
In-Reply-To: <20080723201258.GA26156@kroah.com>
Message-ID: <alpine.LFD.1.10.0807231322250.4754@woody.linux-foundation.org>
References: <20080722230208.148102983@mini.kroah.org> <20080722231342.GA8282@suse.de> <20080722231735.GS8282@suse.de> <74d0deb30807230001x176e375cq9a8060c20596f36f@mail.gmail.com> <20080723201258.GA26156@kroah.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Jul 2008, Greg KH wrote:

> On Wed, Jul 23, 2008 at 09:01:34AM +0200, pHilipp Zabel wrote:
> > 
> > There is an ugly typo in the patch below that was fixed by Karl Beldan:
> > http://git.kernel.org/?p=linux/kernel/git/drzeus/mmc.git;a=commit;h=28bbe535df5c461c25eb57affb30e007072429c3
> > 
> > Not sure how you handle this, maybe this patch should only go in
> > together with the other.
> 
> As the above mentioned patch isn't in Linus's tree yet, I can't take it.
> 
> Care to send it to stable@kernel.org when it does go in?  Or is this
> current patch just broken without it and not worth adding at all?

Hmm. I think it's commit 4fe16897c59882420d66f2d503106653d026ed6c 
upstream. I don't know why it has a different SHA1 in the mmc tree, but I 
assume that it's because the MMC tree has rebased at some point. Ugh.

		Linus
