Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbYDTXk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbYDTXk2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 19:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbYDTXkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 19:40:14 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:52623 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbYDTXkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 19:40:13 -0400
Date: Sun, 20 Apr 2008 17:40:11 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: David Miller <davem@davemloft.net>
Cc: bunk@kernel.org, aacraid@adaptec.com,
       James.Bottomley@HansenPartnership.com, wli@holomorphy.com,
       sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] sparc: export kmap_atomic_to_page
Message-ID: <20080420234011.GT20637@parisc-linux.org>
References: <20080414141956.GN6695@cs181133002.pp.htv.fi> <20080415.003910.50277238.davem@davemloft.net> <20080420201443.GB14788@cs181133002.pp.htv.fi> <20080420.132829.220464348.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080420.132829.220464348.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 01:28:29PM -0700, David Miller wrote:
> From: Adrian Bunk <bunk@kernel.org>
> Date: Sun, 20 Apr 2008 23:14:43 +0300
> 
> > On Tue, Apr 15, 2008 at 12:39:10AM -0700, David Miller wrote:
> > > From: Adrian Bunk <bunk@kernel.org>
> > >...
> > > > <--  snip  -->
> > > > 
> > > >   MODPOST 1741 modules
> > > > ERROR: "kmap_atomic_to_page" [drivers/scsi/aacraid/aacraid.ko] undefined!
> > > > ...
> > > > make[2]: *** [__modpost] Error 1
> > > > 
> > > > <--  snip  -->
> > > > 
> > > > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > > 
> > > Applied, thanks Adrian.
> > 
> > Please drop - aacraid no longer uses it in 2.6.26.
> 
> Ok, will do.

Looks like the only remaining user is in mm/shmem.c.  I guess it can be
unexported now?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
