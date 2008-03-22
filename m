Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbYCVRjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbYCVRjw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 13:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbYCVRjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 13:39:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46055 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbYCVRjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 13:39:41 -0400
Subject: Re: ext3 lockdep warning in 2.6.25-rc6
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200803221437.m2MEbO5H003869@agora.fsl.cs.sunysb.edu>
References: <200803221437.m2MEbO5H003869@agora.fsl.cs.sunysb.edu>
Content-Type: text/plain
Date: Sat, 22 Mar 2008 18:38:47 +0100
Message-Id: <1206207527.6437.83.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-03-22 at 10:37 -0400, Erez Zadok wrote:
> I was building a kernel using "make -j 4" inside a unionfs, mounted on top
> of ext3.  The kernel is vanilla 2.6.25-rc6 plus unionfs patches.  At some
> point I forced a cache flush using "echo 3 > /proc/sys/vm/drop_caches" and I
> got the lockdep warning below.  Note that unionfs doesn't appear to be
> involved in this lockdep warning at all, so I suspect this is probably an
> issue between jbd and ext3 directly.

Known issue, drop_caches isn't production quality.

