Return-Path: <linux-kernel-owner+w=401wt.eu-S1759310AbXEaA6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310AbXEaA6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 20:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbXEaA6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 20:58:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952AbXEaA6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 20:58:35 -0400
Date: Thu, 31 May 2007 01:57:37 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: David Chinner <dgc@sgi.com>, Tejun Heo <htejun@gmail.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org,
       Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Message-ID: <20070531005737.GQ25091@agk.fab.redhat.com>
Mail-Followup-To: device-mapper development <dm-devel@redhat.com>,
	David Chinner <dgc@sgi.com>, Tejun Heo <htejun@gmail.com>,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org,
	Andreas Dilger <adilger@clusterfs.com>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528024559.GA85884050@sgi.com> <18010.17713.76863.245176@notabene.brown> <20070528042926.GC85884050@sgi.com> <18014.6860.989819.665778@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18014.6860.989819.665778@notabene.brown>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 10:46:04AM +1000, Neil Brown wrote:
> What if the truth changes (as can happen with md or dm)?

You get notified in endio() that the barrier had to be emulated?
 
Alasdair
-- 
agk@redhat.com
