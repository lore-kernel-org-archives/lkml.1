Return-Path: <linux-kernel-owner+w=401wt.eu-S1757843AbZFZL6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843AbZFZL6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 07:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818AbZFZL5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 07:57:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbZFZL5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 07:57:53 -0400
From: Neil Brown <neilb@suse.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Fri, 26 Jun 2009 21:58:29 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19012.47077.328965.919868@notabene.brown>
Cc: "Mike Snitzer" <snitzer@redhat.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Alasdair G Kergon" <agk@redhat.com>, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       "device-mapper development" <dm-devel@redhat.com>
Subject: Re: [dm-devel] REQUEST for new 'topology' metrics to be moved out  of the 'queue' sysfs directory.
In-Reply-To: message from Martin K. Petersen on Thursday June 25
References: <19010.62951.886231.96622@notabene.brown>
	<yq11vp8spxo.fsf@sermon.lab.mkp.net>
	<125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>
	<yq1k530qkm7.fsf@sermon.lab.mkp.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday June 25, martin.petersen@oracle.com wrote:
> >>>>> "Neil" == NeilBrown  <neilb@suse.de> writes:
> 
> And just to make it clear: I completely agree with your argument that
> which knob to choose is I/O size dependent.  My beef with your proposal
> is that I believe the length of the list should be 2.

0, 1, or infinity are the only credible sizes for this sort of list.

However I feel I've written enough on this particular issue (the
particular meaning of the various fields, not the directory location
which I still feel strongly about).

Providing the fields are clearly and unambiguously documented so that
it I can use the documentation to verify the implementation (in md at
least), I will be satisfied.  And if the names of the files actually
match the documented meaning (so e.g. s/io/write/) I might even be
happy.

I'm looking forward to seeing how you justify the name
"physical_block_size" in a way the encompasses possibilities like a
device that stripes over a heterogeneous set of disk drives ;-)

Thanks,
NeilBrown
