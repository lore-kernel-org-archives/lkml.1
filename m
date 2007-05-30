Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbXE3Kns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbXE3Kns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 06:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbXE3Kni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 06:43:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbXE3Kng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 06:43:36 -0400
Date: Wed, 30 May 2007 11:41:15 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: Stefan Bader <sbader3@googlemail.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, David Chinner <dgc@sgi.com>,
       Phillip Susi <psusi@cfl.rr.com>, Stefan Bader <Stefan.Bader@de.ibm.com>,
       Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Message-ID: <20070530104115.GO25091@agk.fab.redhat.com>
Mail-Followup-To: device-mapper development <dm-devel@redhat.com>,
	Stefan Bader <sbader3@googlemail.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
	David Chinner <dgc@sgi.com>, Phillip Susi <psusi@cfl.rr.com>,
	Stefan Bader <Stefan.Bader@de.ibm.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	Tejun Heo <htejun@gmail.com>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528094358.GM25091@agk.fab.redhat.com> <5201e28f0705290225v14fdac44hb0382a4137a84d01@mail.gmail.com> <20070529220500.GA6513@agk.fab.redhat.com> <5201e28f0705300212g3be16464u5ee1a4c80db27a11@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5201e28f0705300212g3be16464u5ee1a4c80db27a11@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 11:12:37AM +0200, Stefan Bader wrote:
> it might be better to indicate -EOPNOTSUPP right from
> device-mapper.
 
Indeed we should.  For support, on receipt of a barrier, dm core should
send a zero-length barrier to all active underlying paths, and delay
mapping any further I/O.

Alasdair
-- 
agk@redhat.com
