Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbYH0NA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbYH0NA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbYH0NAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:00:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41003 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbYH0NAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:00:47 -0400
Date: Wed, 27 Aug 2008 15:03:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Alexander Huemer <alexander.huemer@sbg.ac.at>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: 2.6.27 mtrr fixes do not work when X starts
Message-ID: <20080827130318.GU26610@one.firstfloor.org>
References: <86802c440808141031p2712976cqe2c34d3b986ad810@mail.gmail.com> <48AD8125.7050104@sbg.ac.at> <86802c440808210827y72bb1ec0ndcb97b00d6af3a9c@mail.gmail.com> <48AE90BB.5090800@aitel.hist.no> <86802c440808221024u1f152a73hf060f70e1b16dccb@mail.gmail.com> <48B29320.5070903@aitel.hist.no> <86802c440808251308i609a1c8ay6a7300bf4d0e0758@mail.gmail.com> <48B3CDAF.604@aitel.hist.no> <86802c440808260943k210be3edp54aebc9fea5366f5@mail.gmail.com> <48B54E45.6020206@aitel.hist.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B54E45.6020206@aitel.hist.no>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 02:53:25PM +0200, Helge Hafting wrote:
> Yinghai Lu wrote:
> >On Tue, Aug 26, 2008 at 2:32 AM, Helge Hafting
> ><helge.hafting@aitel.hist.no> wrote:
> 
> >>I hope this helps so the extra bootup parameters can be avoided in the
> >>release kernel.
> >
> >that is a little bit hard.
> 
> Well, perhaps not 2.6.27, but I hope I won't need
> "mtrr_spare_reg_nr=3" forever. Or is my machine a strange
> corner case as far as mtrr's are concerned?

It's just a side effect of having far too much BIOS code 
in the kernel. These basic MTRRs should be set up by the BIOS and when
the kernel starts to think it knows better it ultimatively ends up
being far more platform dependent than it should be.

-Andi
