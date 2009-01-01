Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbZAANd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbZAANd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 08:33:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbZAANdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 08:33:16 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:11678 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755974AbZAANdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 08:33:15 -0500
Message-ID: <495CC612.30800@panasas.com>
Date: Thu, 01 Jan 2009 15:33:06 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
CC: avishay@gmail.com, jeff@garzik.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org,
       linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 7/9] exofs: mkexofs
References: <4947BFAA.4030208@panasas.com>	<4947CA5C.50104@panasas.com>	<20081229121423.efde9d06.akpm@linux-foundation.org>	<495B8D90.1090004@panasas.com> <20081231112515.2d790d1c.akpm@linux-foundation.org>
In-Reply-To: <20081231112515.2d790d1c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Jan 2009 13:33:06.0941 (UTC) FILETIME=[7AEFAAD0:01C96C15]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>> Boaz Harrosh <bharrosh@panasas.com> wrote:
>> When, if, all is fixed, through which tree/maintainer can exofs be submitted?
> 
> I can merge them.  Or you can run a git tree of your own, add it to
> linux-next and ask Linus to pull it at the appropriate time.
> 

Hi James

Andrew suggested that maybe I should push exofs file system directly to
Linus as it is pretty orthogonal to any other work. Sitting in linux-next
will quickly expose any advancements in VFS and will force me to keep
the tree uptodate.

If that is so, and is accepted by Linus, would you rather that also the
open-osd initiator library will be submitted through the same tree?
The conflicts with scsi are very very narrow. The only real dependency
is the ULD being a SCSI ULD. I will routinely ask your ACK on any scsi 
or ULD related patches. Which are very few. This way it will be easier
to manage the dependencies between the OSD work, the OSD pNFS-Objects
trees at pNFS project, and the pNFSD+EXOFS export. One less dependency.

[I already have such a public tree at git.open-osd.org for a while now]

Thanks
Boaz
 
