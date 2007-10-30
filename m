Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbXJ3Vi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbXJ3Vi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 17:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbXJ3Viu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 17:38:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48170
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751989AbXJ3Vit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 17:38:49 -0400
Date: Tue, 30 Oct 2007 14:38:34 -0700 (PDT)
Message-Id: <20071030.143834.127458535.davem@davemloft.net>
To: hch@infradead.org
Cc: sandeen@sandeen.net, andi@firstfloor.org, byron.bbradley@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: XFS Fails Quality Assurance Tests on ARM
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071030175418.GA17768@infradead.org>
References: <p73ps12vxrl.fsf@bingen.suse.de>
	<4726C577.9000209@sandeen.net>
	<20071030175418.GA17768@infradead.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>
Date: Tue, 30 Oct 2007 17:54:18 +0000

> On Tue, Oct 30, 2007 at 12:47:35AM -0500, Eric Sandeen wrote:
> > There was a patch floating around to "fix" it but it's not on-disk
> > compatible w/ x86 & friends, it just makes things consistent for arm.  I
> > think packing some of these structures would take care of it, but this
> > problem could use some attention & testing I think, it's been floating
> > around a long time.
> 
> Do you have a pointer to that patch?  Once the unaliged fields are
> identified simply using get_unaligned on them should fix this issue.

True, but there is the tertiary issue that the packing done by these
platforms might mean that the on-disk format is different on different
platforms which the XFS folks likely want to avoid if possible.
