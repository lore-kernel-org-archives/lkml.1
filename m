Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbYFQPwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbYFQPwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 11:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636AbYFQPwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 11:52:08 -0400
Received: from lazybastard.de ([212.112.238.170]:57030 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073AbYFQPwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 11:52:07 -0400
Date: Tue, 17 Jun 2008 17:51:39 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Maxim Shchetynin <maxim@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org
Subject: Re: AZFS file system proposal
Message-ID: <20080617155139.GF28448@logfs.org>
References: <20080609104650.4f220492@mercedes-benz.boeblingen.de.ibm.com> <20080609125530.GF30405@parisc-linux.org> <20080610104919.504b9826@mercedes-benz.boeblingen.de.ibm.com> <alpine.LNX.1.10.0806110000560.20733@fbirervta.pbzchgretzou.qr> <20080617110655.59c915da@mercedes-benz.boeblingen.de.ibm.com> <alpine.LNX.1.10.0806171133220.6620@fbirervta.pbzchgretzou.qr> <20080617135722.374673b9@mercedes-benz.boeblingen.de.ibm.com> <alpine.LNX.1.10.0806171634040.32473@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.1.10.0806171634040.32473@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 June 2008 16:36:28 +0200, Jan Engelhardt wrote:
> 
> tmpfs plus XIP

That looks seriously disturbed.  Normal filesystems have a backing store
plus a page cache.  Tmpfs removes the backing store and keeps everything
in the page cache.  XIP removes the page cache and leaves everything in
the backing store - which is memory.

Would tmpfs plus XIP remove both the page cache and the backing store?

Jörn

-- 
Data dominates. If you've chosen the right data structures and organized
things well, the algorithms will almost always be self-evident. Data
structures, not algorithms, are central to programming.
-- Rob Pike
