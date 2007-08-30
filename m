Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbXH3JPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbXH3JPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 05:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756185AbXH3JPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 05:15:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40833 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbXH3JPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 05:15:04 -0400
Subject: Re: [PATCH 2.6.21] Return available first timeslice to the
	creator, not parent
From: Peter Zijlstra <peterz@infradead.org>
To: Michal Schmidt <xschmi00@stud.feec.vutbr.cz>
Cc: Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>
In-Reply-To: <46D681B4.90401@stud.feec.vutbr.cz>
References: <m3fy21qx4p.fsf@dhcp-lab-143.englab.brq.redhat.com>
	 <46D681B4.90401@stud.feec.vutbr.cz>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 11:14:59 +0200
Message-Id: <1188465299.6112.34.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-30 at 10:37 +0200, Michal Schmidt wrote:
> Vitaly Mayatskikh skrev:
> > Short-living process returns its timeslice to the parent, this
> > affects process that creates a lot of such short-living threads,
> > because its not a parent for new threads.
> 
> I don't see the point of sending patches for old Linux versions such as 
> 2.6.21, unless it's something applicable to the -stable tree.

The older trees might want to have this, perhaps the .16 by Adrian,
certainly distros still care.

> Do recent kernels with CFS have the same problem?

Very much not comparable, as you probably guessed :-)

> > Patch fixes this issue and
> > doesn't break kabi as does the patch from reporter:
> > http://lkml.org/lkml/2007/4/7/21
> 
> There's no kabi.

True.

