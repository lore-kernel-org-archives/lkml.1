Return-Path: <linux-kernel-owner+w=401wt.eu-S1757051AbZABHP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051AbZABHP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 02:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbZABHPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 02:15:08 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:17056 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751127AbZABHPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 02:15:06 -0500
Message-ID: <495DBEF0.1040801@panasas.com>
Date: Fri, 02 Jan 2009 09:14:56 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 3.0a1 (X11/2008050714)
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       open-osd development <osd-dev@open-osd.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       linux-scsi <linux-scsi@vger.kernel.org>, jeff@garzik.org,
       linux-kernel@vger.kernel.org, avishay@gmail.com,
       viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [osd-dev] [PATCH 7/9] exofs: mkexofs
References: <4947BFAA.4030208@panasas.com> <4947CA5C.50104@panasas.com> <20081229121423.efde9d06.akpm@linux-foundation.org> <495B8D90.1090004@panasas.com> <1230739053.3408.74.camel@localhost.localdomain> <495C8B65.4010202@panasas.com> <20090101232637.GC31367@fieldses.org>
In-Reply-To: <20090101232637.GC31367@fieldses.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jan 2009 07:14:56.0626 (UTC) FILETIME=[D0DE1D20:01C96CA9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan. 02, 2009, 1:26 +0200, "J. Bruce Fields" <bfields@fieldses.org> wrote:
> On Thu, Jan 01, 2009 at 11:22:45AM +0200, Benny Halevy wrote:
>> On Dec. 31, 2008, 17:57 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>>> I don't like it mainly because it's not truly a useful general framework
>>> for others to build on.  However, as argued above, there might not
>>> actually be such a useful framework, so as long as the only two
>>> consumers (you and Lustre) want an interface like this, I'll put it in.
>> Not to mention pnfs over objects which is coming up around the corner.
>> The pnfs-obj layout driver will use the osd initiator library as well
>> for distributed data I/O access (while the metadata server, to be based
>> on exofs accesses the OSD for metadata and security ops too)
> 
> What state is that project in right now?

I hope to release the pnfs-obj layout driver in a few weeks,
after finishing with cleaning up the nfs41 and pnfs patch sets.
Still, there's more work to be done on the back end side, exporting
exofs over (p)NFS, and then we'd be able to provide full pnfs
over objects functionality.

Benny

> 
> --b.
