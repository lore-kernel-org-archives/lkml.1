Return-Path: <linux-kernel-owner+w=401wt.eu-S1759561AbYFWSpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561AbYFWSpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 14:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbYFWSpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 14:45:42 -0400
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.206.88]:37019 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987AbYFWSpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 14:45:42 -0400
X-Greylist: delayed 1858 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jun 2008 14:45:42 EDT
Date: Mon, 23 Jun 2008 14:14:41 -0400
From: Jan Harkes <jaharkes@cs.cmu.edu>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC: 2.6 patch] remove CODA_FS_OLD_API
Message-ID: <20080623181441.GA27170@cs.cmu.edu>
Mail-Followup-To: Adrian Bunk <bunk@kernel.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20080623174833.GH4756@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623174833.GH4756@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 08:48:33PM +0300, Adrian Bunk wrote:
> While fixing CONFIG_ leakages to the userspace kernel headers I ran into 
> CODA_FS_OLD_API.
> 
> After five years, are there still people using the old API left?
> Especially considering that you have to choose at compile time which API 
> to support in the kernel (and distributions tend to offer the new API 
> for some time).
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Jan Harkes <jaharkes@cs.cmu.edu>

The old API can definitely go. Around the time the new interface went in
there were some non-Coda userspace file system implementations that took
a while longer to convert to the new API, but by now they all switched
to the new interface or in some cases to a FUSE-based solution.

Jan

