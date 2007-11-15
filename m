Return-Path: <linux-kernel-owner+w=401wt.eu-S1752480AbXKOFXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbXKOFXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 00:23:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750772AbXKOFW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 00:22:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:56464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbXKOFW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 00:22:56 -0500
From: Neil Brown <neilb@suse.de>
To: "Dan Williams" <dan.j.williams@intel.com>
Date: Thu, 15 Nov 2007 16:22:48 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18235.55208.76197.230486@notabene.brown>
Cc: "Greg KH" <greg@kroah.com>, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stable <stable@kernel.org>
Subject: Re: [stable] [PATCH 000 of 2] md: Fixes for md in 2.6.23
In-Reply-To: message from Dan Williams on Tuesday November 13
References: <20071022171426.31103.patches@notabene>
	<20071114002214.GA31928@kroah.com>
	<20071114002308.GB31928@kroah.com>
	<e9c3a7c20711131936t3c5f858cm8937b24d97fe998c@mail.gmail.com>
	<20071114034325.GA25558@kroah.com>
	<e9c3a7c20711132136t6cc9a91avb1d1ddf257701331@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday November 13, dan.j.williams@intel.com wrote:
> 
> raid5-fix-unending-write-sequence.patch is in -mm and I believe is
> waiting on an Acked-by from Neil?
> 

It seems to have just been sent on to Linus, so it probably will go in
without:

   Acked-By: NeilBrown <neilb@suse.de>

I'm beginning to think that I really should sit down and make sure I
understand exactly how those STRIPE_OP_ flags are uses.  They
generally make sense but there seem to be a number of corner cases
where they aren't quite handled properly..  Maybe they are all found
now, or maybe....

NeilBrown
