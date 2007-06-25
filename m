Return-Path: <linux-kernel-owner+w=401wt.eu-S1753265AbXFYXhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbXFYXhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 19:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbXFYXhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 19:37:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:60352 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbXFYXhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 19:37:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,460,1175497200"; 
   d="scan'208";a="243268768"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Mon, 25 Jun 2007 16:36:52 -0700
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
References: <200706251434.43863.jesse.barnes@intel.com> <20070625233433.GA32306@one.firstfloor.org>
In-Reply-To: <20070625233433.GA32306@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706251636.53636.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 25, 2007 4:34:33 Andi Kleen wrote:
> > This patch fixes a bug in the last patch that caused the code to
> > run on non-Intel machines (AMD machines apparently don't need it
>
> Actually the problem can happen on AMD too, but the symptoms can
> be different and there can be more wrong than just the MTRRs.

I should have been more specific in the changelog.  My understanding is 
that AMD systems don't need it for memory above 4G, and since the code 
doesn't handle holes (no test systems, nor any real reports that I've 
seen), it's not that useful for finding problems below 4G.  We can 
always change that later if needed though.

Thanks,
Jesse
