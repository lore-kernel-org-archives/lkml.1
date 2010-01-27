Return-Path: <linux-kernel-owner+w=401wt.eu-S1756354Ab0A0Wdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab0A0Wdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 17:33:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756329Ab0A0Wdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 17:33:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50018 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756102Ab0A0Wde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 17:33:34 -0500
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.33-rc5
From: James Bottomley <James.Bottomley@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100127222404.6dfdd0a7@lxorguk.ukuu.org.uk>
References: <1264614691.3075.19.camel@mulgrave.site>
	 <20100127222404.6dfdd0a7@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jan 2010 16:33:29 -0600
Message-Id: <1264631609.3075.94.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-27 at 22:24 +0000, Alan Cox wrote:
> > Penchala Narasimha Reddy Chilakala, ERS-HCLTech (1):
> >       aacraid: fix File System going into read-only mode
> 
> If aacraid is actually getting patches then see
> also http://bugzilla.kernel.org/show_bug.cgi?id=11120 which I found
> bugzilla tidyying.
> 
> Contains a patch and test confirmations

So the patch it contains is almost certainly wrong in general; Mark was
just suggesting it as a trial ... it might work for specific adapter
versions but reducing the queue depth by half globally will impact
performance noticeably.  The bug report does rather sound like cabling
issues are leading to a firmware related problem.

James


