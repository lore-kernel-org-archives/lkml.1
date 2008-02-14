Return-Path: <linux-kernel-owner+w=401wt.eu-S934684AbYBNBWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934684AbYBNBWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 20:22:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758708AbYBNBWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 20:22:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41359
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757036AbYBNBWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 20:22:19 -0500
Date: Wed, 13 Feb 2008 17:22:51 -0800 (PST)
Message-Id: <20080213.172251.249294145.davem@davemloft.net>
To: James.Bottomley@HansenPartnership.com
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.25-rc1
From: David Miller <davem@davemloft.net>
In-Reply-To: <1202951513.3109.101.camel@localhost.localdomain>
References: <1202947364.3109.96.camel@localhost.localdomain>
	<20080213161643.65a5a779.akpm@linux-foundation.org>
	<1202951513.3109.101.camel@localhost.localdomain>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Wed, 13 Feb 2008 19:11:53 -0600

> 
> On Wed, 2008-02-13 at 16:16 -0800, Andrew Morton wrote:
> > kill-warnings-in-mptbaseh-on-parisc64.patch
> 
> >   Warning fixes.
> 
> Not sure ... LSI is supposed to be processing this.

James, please don't push build warning fixes and the like back to the
driver maintainers.

This is your domain as SCSI maintainer, and you should integrate these
kinds of things directly and as promptly as possible.

This is doubly true if the "driver maintainer" can't be bothered
to ACK or fixup the patch for months.

Otherwise this kind of stuff rots, and diligent people like Andrew
(and the patch submitter, whoever that might be) get extremely
frustrated.
