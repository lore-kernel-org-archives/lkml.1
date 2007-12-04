Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377AbXLDPhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbXLDPhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 10:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbXLDPgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 10:36:54 -0500
Received: from gherkin.frus.com ([192.158.254.49]:56457 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbXLDPgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 10:36:53 -0500
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
In-Reply-To: <20071204121618.GA26132@elte.hu> "from Ingo Molnar at Dec 4, 2007
 01:16:18 pm"
To: Ingo Molnar <mingo@elte.hu>
Date: Tue, 4 Dec 2007 09:36:40 -0600 (CST)
CC: Michael Cree <mcree@orcon.net.nz>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rjw@sisk.pl, rth@twiddle.net, ink@jurassic.park.msu.ru,
       linux-scsi@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20071204153641.2938DDBA2@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> once you are done with the download of the initial cloned git repository 
> (which is 200MB+), all the bisection steps will be local and you'll be 
> only limited by kernel rebuild speed and by bootup and testing speed, 
> not by network bandwidth.

ACK.  Have tested two kernels in the past 24 hours, and the third is
building as I type this.  The builds seem to be taking about 3 hours
each.  First two tests good, so the offending commit is somewhere in
the last 25% (roughly) of the changes between -rc2 and -rc3: git says
82 revisions left to test.  Might have this painted into a corner in
the next day or so.  I'll try to be quick about it, since -rc4 is out.

> ( once you have the cloned repository i'd suggest for you to keep it - 
>   that way you can track susequent kernels via "git-pull" and it uses a 
>   very network-efficient delta protocol. )

Will do...  I'm in the fortunate position of having enough disk space
on my Alpha that I can maintain multiple trees for this kind of effort.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "They couldn't hit an elephant at this dist- "
rct@frus.com       |   - Last words of Union General John Sedgwick,
                   |  Battle of Spotsylvania Court House, U.S. Civil War
------------------------------------------------------------------------
