Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbZFYRoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbZFYRoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 13:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbZFYRoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 13:44:01 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:28242 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbZFYRn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 13:43:59 -0400
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: NeilBrown <neilb@suse.de>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Mike Snitzer <snitzer@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>
Subject: Re: [dm-devel] REQUEST for new 'topology' metrics to be moved out of the 'queue' sysfs directory.
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <19010.62951.886231.96622@notabene.brown>
	<yq11vp8spxo.fsf@sermon.lab.mkp.net>
	<125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>
	<4A43612F.2000100@anonymous.org.uk>
Date: Thu, 25 Jun 2009 13:43:23 -0400
In-Reply-To: <4A43612F.2000100@anonymous.org.uk> (John Robinson's message of
	"Thu, 25 Jun 2009 12:36:15 +0100")
Message-ID: <yq1fxdoqkec.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: abhmt006.oracle.com [141.146.116.15]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4A43B73F.0270:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "John" == John Robinson <john.robinson@anonymous.org.uk> writes:

John> Even sadder, when a raid 0/4/5/6 is reshaped over more discs (and
John> probably other scenarios outwith md),

I'm not sure I agree with the whole "sad" sentiment.  Just because
ext[234] doesn't query devices automatically doesn't mean the technology
doesn't exist.  I wrote the MD/LVM extraction code for XFS in 2001.


John> both stripe-width and stride-size change. Is there any prospect
John> this new stacking could give us the opportunity to tell our client
John> (LVM, filesystem, whatever) about the change, or that they'll be
John> able to take advantage of it?

When you resize the fs it would have to compare the new topology to the
old one and adjust accordingly.

-- 
Martin K. Petersen	Oracle Linux Engineering
