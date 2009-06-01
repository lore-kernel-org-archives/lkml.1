Return-Path: <linux-kernel-owner+w=401wt.eu-S1752025AbZFAFNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbZFAFNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 01:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbZFAFN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 01:13:26 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:53566 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbZFAFNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 01:13:25 -0400
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, Neil Brown <neilb@suse.de>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       raz ben yehuda <raziebe@gmail.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: linux-next: md tree build failure
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20090525153346.758483fc.sfr@canb.auug.org.au>
	<20090525061552.GH11363@kernel.dk>
	<20090601144218.26810ec8.sfr@canb.auug.org.au>
Date: Mon, 01 Jun 2009 01:13:11 -0400
In-Reply-To: <20090601144218.26810ec8.sfr@canb.auug.org.au> (Stephen
	Rothwell's message of "Mon, 1 Jun 2009 14:42:18 +1000")
Message-ID: <yq163fga654.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: abhmt009.oracle.com [141.146.116.18]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4A236369.014D:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Stephen" == Stephen Rothwell <sfr@canb.auug.org.au> writes:

>> > Caused by commit e1defc4ff0cf57aca6c5e3ff99fa503f5943c1f1 ("block:
>> > Do away with the notion of hardsect_size") from the block tree
>> > interacting with commit 131e4477401ae76a9cbe8539e4b7819e04cfba36
>> > ("md: raid0: chunk size check in raid0_run") from the md tree.

Stephen> So, is anything happening about these?  I still get these (and
Stephen> the dm) build failures.

There's a replacement DM patch kit brewing that will hopefully come your
way shortly.  It replaces the patches currently in Alasdair's tree.
Mike sent the kit out for review last week and I'm currently testing it.


I don't know what Neil's plans are.  Neil: Do you want to rebase your
tree, fix up the conflicting patches or how would you like to handle
this?

-- 
Martin K. Petersen	Oracle Linux Engineering
