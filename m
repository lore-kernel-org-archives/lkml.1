Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbXE2NiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbXE2NiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 09:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbXE2NiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 09:38:17 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60536 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbXE2NiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 09:38:15 -0400
In-Reply-To: <20070526062906.GA26553@nineveh.local>
To: jfannin@gmail.com (Joseph Fannin)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Safford <safford@us.ibm.com>, jfannin@gmail.com,
       linux-kernel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>,
       serue@linux.vnet.ibm.com
MIME-Version: 1.0
Subject: Re: 2.6.22-rc1-mm1: evm BUG when reading sysfs file
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF92C62155.924AEB85-ON852572EA.004A8D21-852572EA.004AE5DE@us.ibm.com>
From: Reiner Sailer <sailer@us.ibm.com>
Date: Tue, 29 May 2007 09:38:15 -0400
X-MIMETrack: Serialize by Router on D01ML605/01/M/IBM(Build V80_M4_03042007|March 04, 2007) at
 05/29/2007 09:38:15,
	Serialize complete at 05/29/2007 09:38:15
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

jfannin@gmail.com (Joseph Fannin) wrote on 05/26/2007 02:29:07 AM:

> On Fri, May 25, 2007 at 10:28:22PM -0400, Reiner Sailer wrote:
> > On Tue, 22 May 2007 03:25:48 -0400
> > jfannin@gmail.com (Joseph Fannin) wrote:
> >
> 
> > > I've been getting this since 2.6.21-rc7-mm1:
> 
....
> >
> > Joseph,
> >
> > thank you for posting this problem. I cannot reconstruct it on my 
machine.
> >
> > Could you tell us which kernel configuration you used 
(drivers/char/tpm
> > and security settings) ?
> > Does it disappear when IMA is disabled in the kernel config?
> 
>     I've found that disabling CONFIG_SYSFS_DEPRECATED makes the
> BUG message go away; maybe that's what you're missing?
> 
>     I've also attached my .config -- but it has lots of stuff turned
> on, so it may be faster to try flipping CONFIG_SYSFS_DEPRECATED on a
> slimmer config, if you'd like.
> 
>     Disabling IMA doesn't change the message; it's still there.
> 
>     Thanks!
> --
> Joseph Fannin
> jfannin@gmail.com
> 

Thank you very much for these helpful details. We are working on a 
solution.

Best
Reiner
