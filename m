Return-Path: <linux-kernel-owner+w=401wt.eu-S933675AbXEPSNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933675AbXEPSNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 14:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759753AbXEPSNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 14:13:36 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:52786 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756332AbXEPSNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 14:13:35 -0400
Date: Wed, 16 May 2007 20:12:09 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Chris Mason <chris.mason@oracle.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: filesystem benchmarking fun
In-Reply-To: <20070516144205.GV26766@think.oraclecorp.com>
Message-ID: <Pine.LNX.4.61.0705162010370.9019@yvahk01.tjqt.qr>
References: <20070516144205.GV26766@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 16 2007 10:42, Chris Mason wrote:
>
>For example, I'll pick on xfs for a minute.  compilebench shows the
>default FS you get from mkfs.xfs is pretty slow for untarring a bunch of
>kernel trees.

I suppose you used 'nobarrier'? [ http://lkml.org/lkml/2006/5/19/33 ]

>Dave Chinner gave me some mount options that make it
>dramatically better,

and `mkfs.xfs -l version=2` is also said to make it better

>but it still writes at 10MB/s on a sata drive that
>can do 80MB/s.  Ext3 is better, but still only 20MB/s. 
>
>Both are presumably picking a reasonable file and directory layout.
>Still, our writeback algorithms are clearly not optimized for this kind
>of workload.  Should we fix it?

Also try with tmpfs.



	Jan
-- 
