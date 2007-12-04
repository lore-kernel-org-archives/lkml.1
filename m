Return-Path: <linux-kernel-owner+w=401wt.eu-S1752925AbXLDQ4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbXLDQ4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 11:56:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbXLDQ4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 11:56:30 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44266 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbXLDQ43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 11:56:29 -0500
Date: Tue, 4 Dec 2007 16:56:26 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Mike Snitzer <snitzer@gmail.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [0/4] DST: Distributed storage.
Message-ID: <20071204165625.GA14995@infradead.org>
References: <aqqqqasdzxczc036@2ka.mipt.ru> <11967790263179@2ka.mipt.ru> <170fa0d20712040725o506a47cayb137993041ec3a63@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170fa0d20712040725o506a47cayb137993041ec3a63@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  * fixed bug with XFS metadata update (it can provide slab pages to the
> >         DST, so it is not allowed to transfer them using ->sendpage())

xfs hasn't been doing that anymore for quite a while.  Block drivers
don't need hacks for it anymore, epsecially as it's not reliably
detectable.

