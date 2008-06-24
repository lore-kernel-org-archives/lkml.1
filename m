Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbYFXGxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbYFXGxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 02:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbYFXGxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 02:53:40 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:64115 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbYFXGxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 02:53:39 -0400
Date: Tue, 24 Jun 2008 00:53:20 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] extX: convert prink(KERN_WARNING) to extX_warning()
In-reply-to: <20080624002023.0fadc1d1@olorin>
To: FD Cami <francois.cami@free.fr>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Kasper Sandberg <lkml@metanurb.dk>, Eric Sandeen <sandeen@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
Message-id: <20080624065320.GG6239@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <20080622201841.669ff882@olorin>
 <20080623203107.GD6239@webber.adilger.int> <20080624002023.0fadc1d1@olorin>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 24, 2008  00:20 +0200, FD Cami wrote:
> On Mon, 23 Jun 2008 14:31:07 -0600
> Andreas Dilger <adilger@sun.com> wrote:
> > The one issue is that KERN_ERR != KERN_WARNING, so these errors might
> > not be visible on the console, or may not be saved to the syslog.
> 
> Hmmm, I did not replace any KERN_ERR by ext3_warning / KERN_WARNING, but
> made those KERN_ERR calls more verbose. Does that change anything ?

My apologies, when I started reading the patch I was thinking it
replaced all of the printk's in ext3_fill_super(), which it in fact
does not.

> For the record, I wanted to replace KERN_ERR calls by calls to a wrapper
> much like ext3_warning (but obviously calling KERN_ERR), later on.

OK, that's in line with what I was suggesting.  Carry on :-).

> > Note that you need to split up the patches for ext2, ext3, ext4 into
> > separate emails.  I'd suggest just sending one of them until we agree
> > on what is right, then submitting the rest afterward.
> 
> OK. I did ext3/ext4 at once because of what Andrew replied to Kasper :
> "We like to keep ext3 and ext4 in sync as much as poss, please."
> http://lkml.org/lkml/2008/6/9/79
> But I can do ext3 first and then back / forward port to ext2 and ext4 as
> well, as you suggest.

Yes, it is definitely desirable to have patches for all of them, but
always in separate emails.  If you feel the patches are ready to go,
then go ahead and send all 3 at once.  I just thought it might save
some work and list traffic if we agree on one of the patches and then
produce the other two to match.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

