Return-Path: <linux-kernel-owner+w=401wt.eu-S1756414AbXJHMkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbXJHMkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 08:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbXJHMkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 08:40:17 -0400
Received: from styx.suse.cz ([82.119.242.94]:45788 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754653AbXJHMkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 08:40:15 -0400
Date: Mon, 8 Oct 2007 15:02:32 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       sho@tnes.nec.co.jp, jack@suse.cz, clameter@sgi.com
Subject: Re: [PATCH 2/2] ext2: Avoid rec_len overflow with 64KB block size
Message-ID: <20071008130232.GD8091@duck.suse.cz>
References: <20070828190551.415127746@sgi.com> <20070828190735.292638294@sgi.com> <1188432669.3799.35.camel@localhost.localdomain> <1188434857.3799.76.camel@localhost.localdomain> <1191285346.11737.58.camel@localhost.localdomain> <20071004131207.65406a7b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071004131207.65406a7b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 04-10-07 13:12:07, Andrew Morton wrote:
> On Mon, 01 Oct 2007 17:35:46 -0700
> Mingming Cao <cmm@us.ibm.com> wrote:
> 
> > ext2: Avoid rec_len overflow with 64KB block size
> > 
> > From: Jan Kara <jack@suse.cz>
> > 
> > With 64KB blocksize, a directory entry can have size 64KB which does not fit
> > into 16 bits we have for entry lenght. So we store 0xffff instead and convert
> > value when read from / written to disk.
> 
> This patch clashes in non-trivial ways with
> ext2-convert-to-new-aops-fix.patch and perhaps other things which are
> already queued for 2.6.24 inclusion, so I'll need to ask for an updated
> patch, please.
> 
> Also, I'm planing on merging the ext2 reservations code into 2.6.24, so if
> we're aiming for complete support of 64k blocksize in 2.6.24's ext2,
> additional testing and checking will be needed.
  OK, I'll fixup those rejects and send a new patch.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
