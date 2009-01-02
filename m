Return-Path: <linux-kernel-owner+w=401wt.eu-S932519AbZABWqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519AbZABWqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 17:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757491AbZABWqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 17:46:33 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44060 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757436AbZABWqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 17:46:32 -0500
Subject: Re: [PATCH 7/9] exofs: mkexofs
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, avishay@gmail.com,
       jeff@garzik.org, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       osd-dev@open-osd.org, linux-kernel@vger.kernel.org,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <495CC612.30800@panasas.com>
References: <4947BFAA.4030208@panasas.com>	<4947CA5C.50104@panasas.com>
	 <20081229121423.efde9d06.akpm@linux-foundation.org>
	 <495B8D90.1090004@panasas.com>
	 <20081231112515.2d790d1c.akpm@linux-foundation.org>
	 <495CC612.30800@panasas.com>
Content-Type: text/plain
Date: Fri, 02 Jan 2009 16:46:26 -0600
Message-Id: <1230936386.3304.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-01 at 15:33 +0200, Boaz Harrosh wrote:
> Andrew Morton wrote:
> >>> Boaz Harrosh <bharrosh@panasas.com> wrote:
> >> When, if, all is fixed, through which tree/maintainer can exofs be submitted?
> > 
> > I can merge them.  Or you can run a git tree of your own, add it to
> > linux-next and ask Linus to pull it at the appropriate time.
> > 
> 
> Hi James
> 
> Andrew suggested that maybe I should push exofs file system directly to
> Linus as it is pretty orthogonal to any other work. Sitting in linux-next
> will quickly expose any advancements in VFS and will force me to keep
> the tree uptodate.
> 
> If that is so, and is accepted by Linus, would you rather that also the
> open-osd initiator library will be submitted through the same tree?
> The conflicts with scsi are very very narrow. The only real dependency
> is the ULD being a SCSI ULD. I will routinely ask your ACK on any scsi 
> or ULD related patches. Which are very few. This way it will be easier
> to manage the dependencies between the OSD work, the OSD pNFS-Objects
> trees at pNFS project, and the pNFSD+EXOFS export. One less dependency.
> 
> [I already have such a public tree at git.open-osd.org for a while now]

Since it's sitting in SCSI, at least the libosd piece belongs over the
SCSI mailing list, so I think it makes sense to continue updating it via
the SCSI tree.

What's the status of the major number request from LANANA.  That's patch
number one, and I haven't heard that they've confirmed the selection of
260 yet; or is LANANA now dead and it's who gets the major into the tree
first?

James


