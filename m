Return-Path: <linux-kernel-owner+w=401wt.eu-S1758229AbXFZPDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbXFZPDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 11:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbXFZPCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 11:02:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42051 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380AbXFZPCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 11:02:54 -0400
Date: Tue, 26 Jun 2007 17:02:49 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Message-ID: <20070626150249.GA7877@one.firstfloor.org>
References: <200706251434.43863.jesse.barnes@intel.com> <20070625233433.GA32306@one.firstfloor.org> <200706251636.53636.jesse.barnes@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706251636.53636.jesse.barnes@intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 04:36:52PM -0700, Jesse Barnes wrote:
> On Monday, June 25, 2007 4:34:33 Andi Kleen wrote:
> > > This patch fixes a bug in the last patch that caused the code to
> > > run on non-Intel machines (AMD machines apparently don't need it
> >
> > Actually the problem can happen on AMD too, but the symptoms can
> > be different and there can be more wrong than just the MTRRs.
> 
> I should have been more specific in the changelog.  My understanding is 
> that AMD systems don't need it for memory above 4G, and since the code 

AMD systems need MTRRs to get cached memory too, or what is your point?

There was a new memory remapping feature in RevE but I didn't think
it obsoleted MTRRs.

We've also had systems with this issue.

-Andi
