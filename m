Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbZGJTHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbZGJTHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 15:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbZGJTHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 15:07:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50140 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440AbZGJTHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 15:07:41 -0400
Date: Fri, 10 Jul 2009 15:07:28 -0400
From: Dave Jones <davej@redhat.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 10 (cpufreq oops)
Message-ID: <20090710190728.GA6240@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20090710151846.c7ebec37.sfr@canb.auug.org.au> <200907102054.37956.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907102054.37956.bzolnier@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 08:54:37PM +0200, Bartlomiej Zolnierkiewicz wrote:
 > On Friday 10 July 2009 07:18:46 Stephen Rothwell wrote:
 > > Hi all,
 > > 
 > > Changes since 20090709:
 >  
 > [ this particular problem goes back to next-20090709 ]
 > 
 > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
 > Subject: [PATCH] cpufreq: fix OOPS in __cpufreq_governor()
 > 
 > commit 0d923c15b774bed3491400bae6db50481ac8b9e4 ("[CPUFREQ] Factor out
 > policy setting from cpufreq_add_dev") accidentally reordered new_policy
 > setup and policy->governor reset.
 > 
 > Fix it, also update comment to match the function name while at it.

Thanks Bart, good eyes.

I'll fold this into the original patch and regenerate the tree.

	Dave 
