Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbZDNOuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbZDNOuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 10:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbZDNOuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 10:50:03 -0400
Received: from main.gmane.org ([80.91.229.2]:50022 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbZDNOuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 10:50:02 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Peter Niemayer <niemayer@isg.de>
Subject: XFS support for TRIM / blkdev_issue_discard?
Date: Tue, 14 Apr 2009 16:44:01 +0200
Message-ID: <49E4A131.5040309@isg.de>
References: <20090331053013.7642414167108@attica.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: xfs@oss.sgi.com
X-Gmane-NNTP-Posting-Host: barriere.frankfurter-softwarefabrik.de
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
In-Reply-To: <20090331053013.7642414167108@attica.americas.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Felix Blyakher,

do you know whether there are plans to support the ATA TRIM command /
blkdev_issue_discard() call in XFS for Linux anytime soon?

I ask because as someone who is currently benchmarking solid state disks
for certain usage scenarios I noticed that other filesystems are starting
to support the discarding of unused blocks, which allows to prevent
performance-degradation of SSDs during heavy use.
(See e.g. http://www.mail-archive.com/cluster-devel@redhat.com/msg03401.html
  on the GFS2 support for the discard feature, it seems not too hard
  to implement the support)

Amongst other SSDs, we have one in our tests that supports the ATA TRIM command,
and I would like to test the benefits of it, even if that requires me
to install an early kernel pre-release.

(Currently, XFS is our favorite filesystem for several reasons, so it would
be great if we could run our TRIM-support-benchmarks using it)

Regards,

Peter Niemayer

