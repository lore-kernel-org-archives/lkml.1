Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbZFYMCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbZFYMCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 08:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbZFYMBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 08:01:53 -0400
Received: from hole.yuiop.co.uk ([89.145.97.62]:36627 "EHLO hole.yuiop.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772AbZFYMBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 08:01:50 -0400
X-Greylist: delayed 1520 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jun 2009 08:01:50 EDT
Message-ID: <4A43612F.2000100@anonymous.org.uk>
Date: Thu, 25 Jun 2009 12:36:15 +0100
From: John Robinson <john.robinson@anonymous.org.uk>
Organization: None; Disorganization: Total
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.8.1.22) Gecko/20090605 Lightning/0.9 Thunderbird/2.0.0.22 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Mike Snitzer <snitzer@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>
Subject: Re: [dm-devel] REQUEST for new 'topology' metrics to be moved out
 of the 'queue' sysfs directory.
References: <19010.62951.886231.96622@notabene.brown>    <yq11vp8spxo.fsf@sermon.lab.mkp.net> <125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>
In-Reply-To: <125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/06/2009 12:07, NeilBrown wrote:
[...]
> stripe-width is only really needed on raid4/5/6 as it is aimed at
> avoiding read-modify-write, so it would be the stripe size, which would
> be minimum_io_size.
[...]
> stride-size is used for raid0 or raid4, or the "Asymmetric" raid5 layouts.
> It allows ext3 to stagger which drive certain 'hot' data structures are
> on.  The current metrics don't allow for that at all.
> I'm not saying they should, and I'm not sure how they could.  But it
> is sad.

Even sadder, when a raid 0/4/5/6 is reshaped over more discs (and 
probably other scenarios outwith md), both stripe-width and stride-size 
change. Is there any prospect this new stacking could give us the 
opportunity to tell our client (LVM, filesystem, whatever) about the 
change, or that they'll be able to take advantage of it?

Cheers,

John.
