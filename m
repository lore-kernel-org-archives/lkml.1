Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbYIJCow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbYIJCow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 22:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbYIJCoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 22:44:44 -0400
Received: from sh.osrg.net ([192.16.179.4]:42359 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbYIJCon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 22:44:43 -0400
Date: Wed, 10 Sep 2008 11:43:37 +0900
To: eo@nebensachen.de
Cc: jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: Block: Trouble with kobject initialisation for blk_cmd_filter
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <87prndp89q.fsf@denkblock.local>
References: <20080909214602L.fujita.tomonori@lab.ntt.co.jp>
	<20080909131850.GL20055@kernel.dk>
	<87prndp89q.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080910114347Z.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Sep 2008 18:57:05 +0200
Elias Oltmanns <eo@nebensachen.de> wrote:

> Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Tue, Sep 09 2008, FUJITA Tomonori wrote:
> [...]
> >> The sysfs changes looks too much for 2.6.27-rcX but without the sysfs
> >> changes, we have the cmdfilter under /sys/block/sda/queue/, right? We
> >> don't need to worry about compatibility, but /sys/block/sda is more
> >> appropriate? (though I don't think that the cmd filter is a good idea
> >> so I don't care much).
> >
> > I agree, under sda/ makes a lot more sense than under sda/queue/
> 
> Well, but why is it in struct request_queue then? Is it going to be
> moved back to the gendisk eventually?

I don't think that we can. It broke many things so I moved it to
request_queue.

http://marc.info/?l=linux-scsi&m=121706317031777&w=2


Well, it turned out that it doesn't work too... Sorry about that.
