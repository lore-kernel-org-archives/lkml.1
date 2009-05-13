Return-Path: <linux-kernel-owner+w=401wt.eu-S1760881AbZEMTdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760881AbZEMTdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 15:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbZEMTdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 15:33:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33798 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbZEMTdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 15:33:46 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: crimil tradalo <crimiltradalo@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Martin K. Petersen" <mkp@mkp.net>
Subject: Re: filesystem with integrity checking
References: <d978a99e0905131013p645317dfy2747b531e550ba9d@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 13 May 2009 15:33:42 -0400
In-Reply-To: <d978a99e0905131013p645317dfy2747b531e550ba9d@mail.gmail.com>
	(crimil tradalo's message of "Wed, 13 May 2009 13:13:58 -0400")
Message-ID: <x49eiusu7ah.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

crimil tradalo <crimiltradalo@gmail.com> writes:

> I am looking for a filesystem that supports integrity checking of
> files with some kind of checksum/hash.
>
> For example, for each block an SHA hash is stored when written and
> verified when read. If the underlying hardware has corrupted the data,
> or returned a different block than expected, the filesystem can detect
> the error.
>
> Obviously, ideal would be integration with the RAID layer so that
> valid data could be found in the redundancy, similar to ZFS, but I
> don't expect this to exist.
>
> The last time I saw this discussed, the consensus seemed to be that it
> wasn't worth the CPU time. I hope that as CPUs have gotten faster and
> data sets larger, more people are noticing how frequent data
> corruption occurs and are beginning to respect the value of an OS
> ensuring the integrity of data on permanent storage. Everyone here
> must have experienced data corruption that is either seemingly-random
> or traced to bad hardware. I'd like to detect such corruption as soon
> as it happens, rather than after it has caused a catastrophic loss of
> data.
>
> If there is none that currently supports this, I am curious if any
> intend to support it eventually. I see it mentioned in BTRFS
> documentation, but considering the low odds of a new filesystem
> actually becoming viable, I'm more interested in a practical solution.
>
> My understanding is that the only filesystems that offer this are ZFS
> and WAFL, neither of which is going to be useful on Linux of course.

You may want to take a look at the DIF/DIX work that Martin K. Petersen
is doing:
  http://oss.oracle.com/projects/data-integrity/

Cheers,
Jeff
