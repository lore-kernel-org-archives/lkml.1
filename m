Return-Path: <linux-kernel-owner+w=401wt.eu-S968336AbXEHPq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968336AbXEHPq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 11:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934591AbXEHPp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 11:45:27 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:53260 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934572AbXEHPpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 11:45:07 -0400
Subject: Re: [git patches] libata reset sequence update
From: James Bottomley <James.Bottomley@SteelEye.com>
To: brking@linux.vnet.ibm.com
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <46409865.9010204@linux.vnet.ibm.com>
References: <20070508063820.GA13469@havoc.gtf.org>
	 <46409865.9010204@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 08 May 2007 10:43:29 -0500
Message-Id: <1178639009.3737.23.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 10:33 -0500, Brian King wrote:
> Jeff Garzik wrote:
> > This has been testing in -mm for a while, but I wanted to send it
> > separated from the main libata update, since it has a chance of
> > breakage.
> > 
> > Most notably, a cumulative timeout (deadline) helps the code from diving
> > into overly-long reset sequences.
> > 
> > Please pull from 'reset-seq' branch of
> > master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git reset-seq
> 
> James,
> 
> FYI - this means you'll probably want to revert this patch:
> 
> http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commitdiff;h=a6506b8e111c9bf9e430e32725b96c0

Jeff,

I'm not happy about this ... I specifically put that reversion in
because you and Tejun told me the the reset change "is scheduled to be
merged but not too soon."

Since you knew I'd taken action on the basis of that advice, could you
at least cc me on the pull request that voids it?

I'll just pull it out of the scsi-misc tree.

James


