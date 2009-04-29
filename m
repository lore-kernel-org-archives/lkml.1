Return-Path: <linux-kernel-owner+w=401wt.eu-S1757456AbZD2QPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456AbZD2QPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 12:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbZD2QPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 12:15:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59900 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbZD2QPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 12:15:10 -0400
Date: Wed, 29 Apr 2009 18:19:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
Cc: "Styner, Douglas W" <douglas.w.styner@intel.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Ma, Chinang" <chinang.ma@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       "Nueckel, Hubert" <hubert.nueckel@intel.com>,
       "Recalde, Luis F" <luis.f.recalde@intel.com>,
       "Nelson, Doug" <doug.nelson@intel.com>,
       "Cheng, Wu-sun" <wu-sun.cheng@intel.com>,
       "Prickett, Terry O" <terry.o.prickett@intel.com>,
       "Shunmuganathan, Rajalakshmi" <rajalakshmi.shunmuganathan@intel.com>,
       "Garg, Anil K" <anil.k.garg@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>
Subject: Re: Mainline kernel OLTP performance update
Message-ID: <20090429161918.GI23223@one.firstfloor.org>
References: <D7C42C27E6CB1E4D8CBDF2F81EA92A2603459F3D6A@azsmsx501.amr.corp.intel.com> <20090429002930.b786348b.akpm@linux-foundation.org> <871vrbrhhy.fsf@basil.nowhere.org> <D7C42C27E6CB1E4D8CBDF2F81EA92A260345A63FAC@azsmsx501.amr.corp.intel.com> <CAC4B8726E86A142B27A9E9A2F2F1247AB6943CB@rrsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC4B8726E86A142B27A9E9A2F2F1247AB6943CB@rrsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 10:06:44AM -0600, Wilcox, Matthew R wrote:
> Is it possible that's simply 'oprofile has a 4% overhead'?

We would expect that overhead to be spread between kernel and
database then, not only database. Maybe it's partly, but it's
probably not the complete answer.

Also at least the user space/context part of oprofile is profiled by 
oprofile too, just not the nmi handler, so if these parts are 
expensive it should be visible.

That the lowering of the period made a difference was interesting.
It might be that oprofile is just getting more and more inaccurate.

-Andi

