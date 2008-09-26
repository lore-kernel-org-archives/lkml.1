Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbYIZJLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbYIZJLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 05:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbYIZJLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 05:11:44 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:43143 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041AbYIZJLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 05:11:44 -0400
Date: Fri, 26 Sep 2008 11:11:35 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: marty <martyleisner@yahoo.com>, linux-kernel@vger.kernel.org,
       martin.leisner@xerox.com
Subject: Re: disk IO directly from PCI memory to block device sectors
Message-ID: <20080926091135.GV2677@kernel.dk>
References: <247018.46515.qm@web50603.mail.re2.yahoo.com> <20080926094653.1e0a9260@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080926094653.1e0a9260@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26 2008, Alan Cox wrote:
> > What I'm looking is for a more generic/driver independent way of sticking
> > contents of PCI ram onto a disk.
> 
> Ermm seriously why not have a userspace task with the PCI RAM mmapped
> and just use write() like normal sane people do ?

To avoid the fault and copy, I would assume.

-- 
Jens Axboe

