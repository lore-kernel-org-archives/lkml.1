Return-Path: <linux-kernel-owner+w=401wt.eu-S1758385AbYAOV66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385AbYAOV66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 16:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756270AbYAOV6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 16:58:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43315 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304AbYAOV6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 16:58:47 -0500
Date: Tue, 15 Jan 2008 22:58:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andy Whitcroft <andyw@uk.ibm.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: Make checkpatch.pl's quiet option not print the summary on no
	errors
Message-ID: <20080115215835.GB2665@elte.hu>
References: <477C3252.1080001@linux.intel.com> <20080115201054.GC21511@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115201054.GC21511@shadowen.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Whitcroft <andyw@uk.ibm.com> wrote:

> On Thu, Jan 03, 2008 at 01:54:42AM +0100, Arjan van de Ven wrote:
> > Subject: Make checkpatch.pl's quiet option not print the summary on no 
> > errors
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > CC: apw@uk.ibm.com
> > 
> > Right now, in quiet mode, checkpatch.pl still prints a summary line 
> > even if the patch is 100% clean. IMO, "quiet mode" should mean "no 
> > output if clean", the patch below makes that so. (This also makes 
> > the quilt integration on my system work nicer :)
> > 
> > Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> 
> While looking to integrate this I discovered that the current default 
> was a desired feature requested by Ingo.  So I guess we need to come 
> up with a combination of options which give us both.

feel free to drop the summary line on -q, i think i only wanted the 
summary to be avilable _somewhere_, so that there's a "quality metric at 
glance" line that one can see. To me that still plays OK with quilt 
because it's a constant reminder that the patch is clean.

	Ingo
