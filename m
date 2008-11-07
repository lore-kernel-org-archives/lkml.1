Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbYKGAmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbYKGAmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 19:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbYKGAmC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 19:42:02 -0500
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:50306 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753157AbYKGAmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 19:42:00 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAM8S9kh5LDmz/2dsb2JhbADCJoFr
X-IronPort-AV: E=Sophos;i="4.33,560,1220193000"; 
   d="scan'208";a="226520021"
Date: Fri, 7 Nov 2008 11:41:31 +1100
From: Dave Chinner <david@fromorbit.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       Hirokazu Takahashi <taka@valinux.co.jp>,
       Ryo Tsuruta <ryov@valinux.co.jp>, Andrea Righi <righi.andrea@gmail.com>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       menage@google.com, ngupta@google.com, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
Message-ID: <20081107004131.GD2373@disturbed>
Mail-Followup-To: Peter Zijlstra <peterz@infradead.org>,
	Rik van Riel <riel@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
	linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
	virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
	Hirokazu Takahashi <taka@valinux.co.jp>,
	Ryo Tsuruta <ryov@valinux.co.jp>,
	Andrea Righi <righi.andrea@gmail.com>,
	Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, fernando@oss.ntt.co.jp,
	balbir@linux.vnet.ibm.com,
	Andrew Morton <akpm@linux-foundation.org>, menage@google.com,
	ngupta@google.com, Jeff Moyer <jmoyer@redhat.com>
References: <20081106153022.215696930@redhat.com> <1225986593.7803.4688.camel@twins> <20081106160154.GA7461@redhat.com> <1225988173.7803.4723.camel@twins> <20081106163957.GB7461@redhat.com> <1225990327.7803.4776.camel@twins> <491321ED.5010103@redhat.com> <1225991487.7803.4801.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225991487.7803.4801.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 06:11:27PM +0100, Peter Zijlstra wrote:
> On Thu, 2008-11-06 at 11:57 -0500, Rik van Riel wrote:
> > Peter Zijlstra wrote:
> > 
> > > The only real issue I can see is with linear volumes, but those are
> > > stupid anyway - non of the gains but all the risks.
> > 
> > Linear volumes may well be the most common ones.
> > 
> > People start out with the filesystems at a certain size,
> > increasing onto a second (new) disk later, when more space
> > is required.
> 
> Are they aware of how risky linear volumes are? I would discourage
> anyone from using them.

In what way are they risky?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
