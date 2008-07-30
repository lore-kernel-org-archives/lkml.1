Return-Path: <linux-kernel-owner+w=401wt.eu-S1760135AbYG3TI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135AbYG3TI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 15:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756716AbYG3TIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 15:08:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41488 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441AbYG3TIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 15:08:19 -0400
Subject: Re: [PATCH] mISDN cleanup user interface
From: David Woodhouse <dwmw2@infradead.org>
To: Karsten Keil <kkeil@suse.de>
Cc: isdn4linux@listserv.isdn4linux.de, Marcel Holtmann <marcel@holtmann.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080730175138.GA12800@pingi.kke.suse.de>
References: <20080729195637.GB25929@pingi.kke.suse.de>
	 <1217362946.27925.137.camel@pmac.infradead.org>
	 <1217365330.417.8.camel@californication>
	 <1217409211.27925.177.camel@pmac.infradead.org>
	 <20080730163314.GB9491@pingi.kke.suse.de>
	 <1217437021.3454.8.camel@pmac.infradead.org>
	 <20080730175138.GA12800@pingi.kke.suse.de>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 20:08:12 +0100
Message-Id: <1217444892.3454.28.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-30 at 19:51 +0200, Karsten Keil wrote:
> > Are you later intending to use the bitmap to mark them as busy/free?
> 
> Yes exactely, and this was the reason why the original code (which used one u_long
> only as channelmap) already used the bit operators, since for a channel allocator
> you should be atomic, but since we are now allow 127 channels we need proper
> locking for the busy/free map anyways and so we do not need atomic operation
> here.

OK, that makes sense then. Your latest patch looks good in that case.

-- 
dwmw2

