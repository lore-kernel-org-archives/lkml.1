Return-Path: <linux-kernel-owner+w=401wt.eu-S1758574AbYBSToO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574AbYBSToO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:44:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbYBSTn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:43:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:44375 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459AbYBSTn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:43:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,377,1199692800"; 
   d="scan'208";a="299952765"
Date: Tue, 19 Feb 2008 11:42:46 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Unable to continue testing of 2.6.25
Message-ID: <20080219194246.GA20438@linux-os.sc.intel.com>
References: <200802171025.30590.elendil@planet.nl> <20080217124650.576990ce@laptopd505.fenrus.org> <p73mypyxx6z.fsf@bingen.suse.de> <20080218085018.05f3190a@laptopd505.fenrus.org> <20080218171159.GA24090@basil.nowhere.org> <20080218093215.5cf611a8@laptopd505.fenrus.org> <adalk5ijdu1.fsf@cisco.com> <20080218110706.221d3015@laptopd505.fenrus.org> <adahcg6jco7.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adahcg6jco7.fsf@cisco.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 11:18:48AM -0800, Roland Dreier wrote:
>  > > AFAIK mapping PCI memory WB is not allowed, so WC is really our only
>  > > choice.
> 
>  > afaik that depends on the BAR being prefetchable or not.
> 
> In my case the BAR is prefetchable.

Even if the BAR is prefetchable, on some platforms mapping MMIO space
as WB can cause bad results like machine check etc.

>  > (and by your argument, ioremap_cached() would not be useful, and since that was, until
>  > 2.6.25-rc1, the default behavior for ioremap(), would have caused massive problems)
> 
> I'm not sure what ioremap_cached() would really do in my case, since
> the MTRRs for PCI memory are set to UC, so without monkeying with MTRR
> contents (which can't really be done safely) the only choices we have
> are leaving the mapping as UC or using PAT to get WC.

thanks,
suresh
