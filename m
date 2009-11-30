Return-Path: <linux-kernel-owner+w=401wt.eu-S1752918AbZK3RBC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbZK3RBC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 12:01:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbZK3RBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 12:01:00 -0500
Received: from gundega.hpl.hp.com ([192.6.19.190]:63824 "EHLO
	gundega.hpl.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbZK3RBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 12:01:00 -0500
X-Greylist: delayed 699 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Nov 2009 12:00:59 EST
Date: Mon, 30 Nov 2009 08:48:52 -0800
From: Jean Tourrilhes <jt@hpl.hp.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the net tree with the
	wireless-current tree
Message-ID: <20091130164852.GA1008@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <20091126141055.d8c67798.sfr@canb.auug.org.au> <1259227989.32372.32.camel@johannes.local> <20091126130153.GA3697@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091126130153.GA3697@tuxdriver.com>
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: jt@hpl.hp.com
User-Agent: Mutt/1.5.18 (2008-05-17)
X-MailScanner-ID: nAUGmsdb026122
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: jt@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 08:01:53AM -0500, John W. Linville wrote:
> On Thu, Nov 26, 2009 at 10:33:09AM +0100, Johannes Berg wrote:
> > On Thu, 2009-11-26 at 14:10 +1100, Stephen Rothwell wrote:
> > > Hi all,
> > > 
> > > Today's linux-next merge of the net tree got a conflict in
> > > net/wireless/wext.c between commit
> > > 9fed059667d35fca9288460106e92dbb8ba35ea1 ("WE: Fix set events not
> > > propagated") from the  tree and commit
> > > 3d23e349d807177eaf519d444677cee86b1a04cf ("wext: refactor") from the net
> > > tree.
> > > 
> > > The latter deleted the file that the former modified.  I just ignored the
> > > wireless-current change and removed the file (which seems to have been
> > > done in the latter change anyway).
> > 
> > The fix should probably have gone to wext-core.c instead?
> 
> Yes.  That's the way I did it in the merge-test branch of wireless-next-2.6.
> 
> Thanks,
> 
> John

	Thanks for fixing that while I was busy in vacation ;-)
	Have fun...

	Jean
