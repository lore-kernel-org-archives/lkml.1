Return-Path: <linux-kernel-owner+w=401wt.eu-S1752095AbZFXHJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbZFXHJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 03:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbZFXHJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 03:09:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52753 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbZFXHJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 03:09:24 -0400
Date: Wed, 24 Jun 2009 08:09:17 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Neil Brown <neilb@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>,
       Ken Milmore <ken.milmore@googlemail.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] Re: Write barriers on MD RAID1
Message-ID: <20090624070917.GB27500@agk-dp.fab.redhat.com>
Mail-Followup-To: Neil Brown <neilb@suse.de>,
	device-mapper development <dm-devel@redhat.com>,
	Ken Milmore <ken.milmore@googlemail.com>,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jens Axboe <jens.axboe@oracle.com>,
	Mikulas Patocka <mpatocka@redhat.com>
References: <4A188CAD.1080009@googlemail.com> <0fa4b1e19d3edb12931e0d641ce2c7d7.squirrel@neil.brown.name> <4A3E3C49.7010907@googlemail.com> <19009.41191.662901.179565@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19009.41191.662901.179565@notabene.brown>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 01:43:35PM +1000, Neil Brown wrote:
> Since this test was added, barriers have not worked on md, and (I
> think) dm and similar devices that don't use __make_request and so
> don't bother to set next_ordered.
 
In dm, we added this:

+       blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN, NULL);

Alasdair

