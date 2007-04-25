Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbXDYXGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbXDYXGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbXDYXGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:06:53 -0400
Received: from mga07.intel.com ([143.182.124.22]:8193 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754508AbXDYXGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:06:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,452,1170662400"; 
   d="scan'208";a="219421182"
Date: Wed, 25 Apr 2007 16:06:49 -0700
From: Valerie Henson <val_henson@linux.intel.com>
To: David Chinner <dgc@sgi.com>, Amit Gud <gud@ksu.edu>,
       Nikita Danilov <nikita@clusterfs.com>,
       David Lang <david.lang@digitalinsight.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       riel@surriel.com, zab@zabbo.net, arjan@infradead.org,
       suparna@in.ibm.com, brandon@ifup.org, karunasagark@gmail.com
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
Message-ID: <20070425230648.GD16129@nifty>
References: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu> <17965.60841.900376.524639@gargle.gargle.HOWL> <Pine.LNX.4.63.0704241123200.7701@qynat.qvtvafvgr.pbz> <17966.23512.363955.141489@gargle.gargle.HOWL> <462E7C47.8080604@ksu.edu> <20070425105434.GX32602149@melbourne.sgi.com> <20070425113834.GT5967@schatzie.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425113834.GT5967@schatzie.adilger.int>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 05:38:34AM -0600, Andreas Dilger wrote:
> 
> The case where only a fsck of the corrupt chunk is done would not find the
> cnode references.  Maybe there needs to be per-chunk info which contains
> a list/bitmap of other chunks that have cnodes shared with each chunk?

Yes, exactly.  One might almost think you had solved this problem
before. :):):)

-VAL
