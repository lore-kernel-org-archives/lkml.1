Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbZF3X6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbZF3X6D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:58:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbZF3X5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:57:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:53546 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294AbZF3X5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:57:51 -0400
From: Neil Brown <neilb@suse.de>
To: Mike Snitzer <snitzer@redhat.com>
Date: Wed, 1 Jul 2009 09:58:32 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19018.42664.764760.682918@notabene.brown>
Cc: jens.axboe@oracle.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: md: Use new topology calls to indicate alignment and I/O sizes
In-Reply-To: message from Mike Snitzer on Tuesday June 30
References: <yq1ws73turf.fsf@sermon.lab.mkp.net>
	<170fa0d20906231444t5432998eo8cc2335c6d4a3a0d@mail.gmail.com>
	<19009.42494.925771.283731@notabene.brown>
	<20090630202432.GG7888@redhat.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday June 30, snitzer@redhat.com wrote:
> 
> Neil,
> 
> Any chance you could make a formal pull request for this MD topology
> support patch for 2.6.31-rc2?

Yes.. I want to include a couple of other patches in the same batch
and I've been a bit distracted lately (by a cold among other things).
I'll try to get this sorted out today.

> 
> NOTE: all the disk_stack_limits() calls must pass the 3rd 'offset' arg
> in terms of bytes and _not_ sectors.  So all of MD's calls to
> disk_stack_limits() should pass: rdev->data_offset << 9

Noted, thanks.

NeilBrown
