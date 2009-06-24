Return-Path: <linux-kernel-owner+w=401wt.eu-S1753074AbZFXHfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbZFXHfD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 03:35:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbZFXHez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 03:34:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:40946 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbZFXHez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 03:34:55 -0400
From: "NeilBrown" <neilb@suse.de>
To: "Neil Brown" <neilb@suse.de>,
       "device-mapper development" <dm-devel@redhat.com>,
       "Ken Milmore" <ken.milmore@googlemail.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Jens Axboe" <jens.axboe@oracle.com>,
       "Mikulas Patocka" <mpatocka@redhat.com>
Date: Wed, 24 Jun 2009 17:34:50 +1000 (EST)
Message-ID: <ee1590411620eede90e75c14fde50244.squirrel@neil.brown.name>
In-Reply-To: <20090624070917.GB27500@agk-dp.fab.redhat.com>
References: <4A188CAD.1080009@googlemail.com>
    <0fa4b1e19d3edb12931e0d641ce2c7d7.squirrel@neil.brown.name>
    <4A3E3C49.7010907@googlemail.com>
    <19009.41191.662901.179565@notabene.brown>
    <20090624070917.GB27500@agk-dp.fab.redhat.com>
Subject: Re: [dm-devel] Re: Write barriers on MD RAID1
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, June 24, 2009 5:09 pm, Alasdair G Kergon wrote:
> On Wed, Jun 24, 2009 at 01:43:35PM +1000, Neil Brown wrote:
>> Since this test was added, barriers have not worked on md, and (I
>> think) dm and similar devices that don't use __make_request and so
>> don't bother to set next_ordered.
>
> In dm, we added this:
>
> +       blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN, NULL);
>

I obviously didn't grep for the right thing.

This will obviously work, but I can't help thinking it is in the wrong
place.  I don't even have a queue in md/raid1, so making a statement
about how it is ordered just doesn't make sense.

Jens?

NeilBrown

