Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbZFZNlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbZFZNlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 09:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbZFZNln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 09:41:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:59446 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921AbZFZNll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 09:41:41 -0400
From: "NeilBrown" <neilb@suse.de>
To: "NeilBrown" <neilb@suse.de>
Date: Fri, 26 Jun 2009 23:41:33 +1000 (EST)
Message-ID: <771af936681abb7ddc2191eb5b6b68d0.squirrel@neil.brown.name>
In-Reply-To: <7c458f2470811a877dd60203b9bbb7ac.squirrel@neil.brown.name>
References: <19010.62951.886231.96622@notabene.brown>
    <yq11vp8spxo.fsf@sermon.lab.mkp.net>
    <125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>
    <20090625194015.GB31415@kernel.dk>
    <19012.49673.454853.975682@notabene.brown>
    <20090626125037.GO23611@kernel.dk>
    <7c458f2470811a877dd60203b9bbb7ac.squirrel@neil.brown.name>
Subject: Re: [dm-devel] REQUEST for new 'topology' metrics to be moved out  
         of the 'queue' sysfs directory.
Cc: "Jens Axboe" <jens.axboe@oracle.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
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

On Fri, June 26, 2009 11:16 pm, NeilBrown wrote:
> On Fri, June 26, 2009 10:50 pm, Jens Axboe wrote:
>> On Fri, Jun 26 2009, Neil Brown wrote:
>
>>> But for now, please please please can we revert the change which made
>>> 'queue' appear in md and dm devices, (and loop and ...) and put these
>>> generic values somewhere ... generic?
>>
>> No we cannot, not without a time machine. 2.6.30 is released, so it's
>> too late to revert things like that, even if we wanted.
>
> Drat... for some reason I was thinking that it only came in in 2.6.31-rc.
> However it is only documented in ABI/testing, not ABI/stable ... if there
> is any value in that distinction, then it should be possible to move it??
>

No, wait.  I was right.  The addition of 'queue' to md/dm devices
happened post-2.6.30.   So are the additions of physical_block_size etc.
So there is still time to put these in a properly generic place.

Do you have a good reason for them going in /queue?

NeilBrown


