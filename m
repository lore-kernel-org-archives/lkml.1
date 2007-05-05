Return-Path: <linux-kernel-owner+w=401wt.eu-S934147AbXEERtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934147AbXEERtg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 13:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934151AbXEERtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 13:49:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38445 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934148AbXEERte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 13:49:34 -0400
Date: Sat, 5 May 2007 10:59:52 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Christoph Hellwig <hch@infradead.org>,
       Anton Altaparmakov <aia21@cam.ac.uk>,
       Bernd Eckenfels <ecki@lina.inka.de>, linux-kernel@vger.kernel.org
Subject: Re: Ext3 vs NTFS performance
Message-ID: <20070505095952.GC9935@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Michael Tokarev <mjt@tls.msk.ru>,
	Anton Altaparmakov <aia21@cam.ac.uk>,
	Bernd Eckenfels <ecki@lina.inka.de>, linux-kernel@vger.kernel.org
References: <E1HjjyF-00022D-00@calista.eckenfels.net> <0733FB88-3E6E-47B7-A55D-704B5C0DB239@cam.ac.uk> <20070504094610.GA31607@infradead.org> <463B55F9.4070606@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463B55F9.4070606@msgid.tls.msk.ru>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 07:49:13PM +0400, Michael Tokarev wrote:
> How about providing a way to stop kernel (or filesystem) to make gaps
> in files instead?  Like some ioctl(fd, FS_NOGAPS, 1) -- pretty much
> like 'doze has, just the opposite (on windows, this flag is "on" by
> default).

Giving filesystems non-hole semantics is non-trivial.  Not allowing
for holes creates a lot of complications in unix-like filesystems.

> But the main point is that samba has to keep track of things which it
> doesn't do now, and those things becomes.. interesting (difficult if
> at all possible to track) in multi-user/concurrent-writes environment.

Samba is there to deal with a braindead protocol and braindead clients,
so let it continue to do that.  No need to push this into the kernel.

