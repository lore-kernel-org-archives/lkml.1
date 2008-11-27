Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbYK0KEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbYK0KEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbYK0KEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:04:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52035 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbYK0KEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:04:32 -0500
Date: Thu, 27 Nov 2008 05:04:26 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] fs: Introduce special dentries for pipes, socket,
	anon fd
Message-ID: <20081127100426.GA18022@infradead.org>
References: <492DDC5C.1050602@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492DDC5C.1050602@cosmosbay.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dentry and indoe patches will take some time to review propery as
they touch hairy code.  For your next respin I'd suggest putting them to
the end of the series so we could eventually merge the other bits
earlier.  Also please changed the special naming to something meanfull,
and please try to have just one single flag in the superblock
controlling all the behvaiour for the can't be unmouynted special case.
