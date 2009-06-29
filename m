Return-Path: <linux-kernel-owner+w=401wt.eu-S1758631AbZF2KxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631AbZF2KxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 06:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbZF2KxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 06:53:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54760 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbZF2KxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 06:53:01 -0400
From: "NeilBrown" <neilb@suse.de>
To: "Jens Axboe" <jens.axboe@oracle.com>
Date: Mon, 29 Jun 2009 20:52:54 +1000 (EST)
Message-ID: <b0aa07ac85efd6040501e4ea875176a3.squirrel@neil.brown.name>
In-Reply-To: <20090629101841.GF23611@kernel.dk>
References: <19010.62951.886231.96622@notabene.brown>
    <yq11vp8spxo.fsf@sermon.lab.mkp.net>
    <125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>
    <20090625194015.GB31415@kernel.dk>
    <19012.49673.454853.975682@notabene.brown>
    <20090626125037.GO23611@kernel.dk>
    <f0d53a7338e1be4e7bdcbe09223c6f73.squirrel@neil.brown.name>
    <20090626132940.GR23611@kernel.dk>
    <19014.4447.248248.63960@notabene.brown>
    <20090629101841.GF23611@kernel.dk>
Subject: Re: [dm-devel] REQUEST for new 'topology' metrics to be moved out 
     of the 'queue' sysfs directory.
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       "Mike Snitzer" <snitzer@redhat.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Alasdair G Kergon" <agk@redhat.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "device-mapper development" <dm-devel@redhat.com>
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, June 29, 2009 8:18 pm, Jens Axboe wrote:
> On Sat, Jun 27 2009, Neil Brown wrote:
>> > There's no such thing as first or second class block devices. The fact
>> > that drivers using ->make_request_fn directly do not utilize the full
>> > scope of the queue isn't a very interesting fact, imho.
>>
>>  Your phrase "drivers using ->make_request_fn directly" seems to
>>  suggest you are looking at things very differently to me.
>>
>>  From my perspective, all drivers use ->make_request_fn equally.
>>  Some set it to "__make_request", some to "md_make_request", others to
>>  "dm_request" or "loop_make_request" etc.
>
> Neil, will you please stop these silly games. Stop trying to invent
> differences based on interpretations of what you read into my replies.


We do seem to be having trouble communicating don't we :-(
Be assured that it is not my intention to play games, silly or otherwise.

Maybe I should just try sending you patches.  Maybe that will
make my meaning clearer.

For the moment, I'm much more interested in the other question,
that of whether I can avoid having a 'queue' directory introduced into
md/dm/etc device directories in sysfs.

NeilBrown

