Return-Path: <linux-kernel-owner+w=401wt.eu-S1757155AbZKKPAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155AbZKKPAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 10:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756865AbZKKPAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 10:00:22 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47874 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544AbZKKPAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 10:00:21 -0500
Date: Wed, 11 Nov 2009 09:54:32 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: Re: linux-next: manual merge of the net/wireless trees with the
	wireless-current tree
Message-ID: <20091111145431.GE4392@tuxdriver.com>
References: <20091111130119.ace8da65.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091111130119.ace8da65.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 01:01:19PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net tree got conflicts in
> drivers/net/wireless/iwlwifi/iwl-1000.c,
> drivers/net/wireless/iwlwifi/iwl-6000.c and
> drivers/net/wireless/iwlwifi/iwl-core.h between commits in the
> wireless-current tree and commits in the net (wireless) tree.
> 
> I used the versions from the net tree except where obvious additions
> had been made in the wireless-current tree.   The fixes may not be
> correct - someone should merge the wireless-current tree into the
> net tree.

Yeah, these conflicts should all be resolved by taking the bigger hunk.
The smaller hunk is duplicative because a patch that has already
been sent to net-next-2.6 is going to be sent for net-2.6 as well
(to support a regression fix).

I'll probably send the wireless-2.6 pull request today.  Perhaps after
Dave pulls that (and Linus pulls from him), Dave can pull net-2.6
into net-next-2.6 to resolve the issue.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
