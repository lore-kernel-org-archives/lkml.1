Return-Path: <linux-kernel-owner+w=401wt.eu-S1753147AbZD0IQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbZD0IQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 04:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbZD0IQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 04:16:06 -0400
Received: from verein.lst.de ([213.95.11.210]:50658 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbZD0IQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 04:16:05 -0400
Date: Mon, 27 Apr 2009 10:13:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: rth@twiddle.net, ink@jurassic.park.msu.ru, hskinnemoen@atmel.com,
       uclinux-dist-devel@blackfin.uclinux.org, dev-etrax@axis.com,
       dhowells@redhat.com, ysato@users.sourceforge.jp,
       linux-m32r@ml.linux-m32r.org, chris@zankel.net
Cc: linux-kernel@vger.kernel.org
Subject: missing preadv/pwritev wireup
Message-ID: <20090427081356.GA32167@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30 added the new preadv/pwritev system calls.  The following
architectures still haven't wired them up:

	alpha, avr32, blackfin, cris, frv, h8300, m32r, xtensa

Can you maintainers please look into wiring these system calls up?

