Return-Path: <linux-kernel-owner+w=401wt.eu-S1760471AbZKZM6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760471AbZKZM6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 07:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759822AbZKZM6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 07:58:17 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36200 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbZKZM6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 07:58:17 -0500
Date: Thu, 26 Nov 2009 08:01:53 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jean Tourrilhes <jt@hpl.hp.com>
Subject: Re: linux-next: manual merge of the net tree with the wireless-current tree
Message-ID: <20091126130153.GA3697@tuxdriver.com>
References: <20091126141055.d8c67798.sfr@canb.auug.org.au> <1259227989.32372.32.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259227989.32372.32.camel@johannes.local>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 10:33:09AM +0100, Johannes Berg wrote:
> On Thu, 2009-11-26 at 14:10 +1100, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Today's linux-next merge of the net tree got a conflict in
> > net/wireless/wext.c between commit
> > 9fed059667d35fca9288460106e92dbb8ba35ea1 ("WE: Fix set events not
> > propagated") from the  tree and commit
> > 3d23e349d807177eaf519d444677cee86b1a04cf ("wext: refactor") from the net
> > tree.
> > 
> > The latter deleted the file that the former modified.  I just ignored the
> > wireless-current change and removed the file (which seems to have been
> > done in the latter change anyway).
> 
> The fix should probably have gone to wext-core.c instead?

Yes.  That's the way I did it in the merge-test branch of wireless-next-2.6.

Thanks,

John
--
John W. Linville
linville@tuxdriver.com
