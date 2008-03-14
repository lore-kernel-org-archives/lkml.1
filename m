Return-Path: <linux-kernel-owner+w=401wt.eu-S1757756AbYCNRyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756AbYCNRyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 13:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbYCNRx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 13:53:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755208AbYCNRx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 13:53:56 -0400
To: Daniel Phillips <phillips@phunq.net>
Cc: David Newall <davidn@davidnewall.com>, david@lang.hm,
       Chris Friesen <cfriesen@nortel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
References: <200803092346.17556.phillips@phunq.net>
	<200803131232.07879.phillips@phunq.net>
	<47D9856E.9010304@davidnewall.com>
	<200803131303.04118.phillips@phunq.net>
From: Jeff Moyer <jmoyer@redhat.com>
Date: Fri, 14 Mar 2008 13:53:30 -0400
In-Reply-To: <200803131303.04118.phillips@phunq.net> (Daniel Phillips's message of "Thu\, 13 Mar 2008 12\:03\:03 -0800")
Message-ID: <x498x0lb3ad.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips <phillips@phunq.net> writes:

> On Thursday 13 March 2008 12:50, David Newall wrote:
>> Daniel Phillips wrote:
>> > The period where you cannot access the data is downtime.  If your script
>> > just does a cp from a disk array to the ram device you cannot just read
>> > from the backing store in that period because you will need to fail over
>> > to the ramdisk at some point, and you cannot just read from the ramdisk
>> > because it is not populated yet.
>> 
>> Wouldn't a raid-1 set comprising disk + ramdisk do that with no downtime?
>
> In raid1, write completion has to wait for write completion on all
> mirror members, so writes run at disk speed.  Reads run at ramdisk
> speed, so your proposal sounds useful, but ramback aims for high
> write performance as well.

Ramback could be an interesting building block.  Consider using a
couple of systems exporting Ramback devices via Evgeniy's distributed
storage target (or something similiar).  In this case, you can have as
many Ramback devices as you want comprise your mirror set to meet your
availability requirements.  Perhaps people are looking at this too
much as an entire solution as opposed to a piece of a bigger puzzle.
I think the idea has merit.

Cheers,

Jeff
