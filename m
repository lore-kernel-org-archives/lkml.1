Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbZCJSyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbZCJSyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 14:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756759AbZCJSyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 14:54:33 -0400
Received: from sh.osrg.net ([192.16.179.4]:52638 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757222AbZCJSyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 14:54:31 -0400
Date: Wed, 11 Mar 2009 03:54:00 +0900 (JST)
Message-Id: <20090311.035400.12547305.ryusuke@osrg.net>
To: sitsofe@yahoo.com
Cc: konishi.ryusuke@lab.ntt.co.jp, akpm@linux-foundation.org, hch@lst.de,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Asking for inclusion of nilfs2 in the mainline kernel
From: Ryusuke Konishi <ryusuke@osrg.net>
In-Reply-To: <20090310174627.GA10667@silver.sucs.org>
References: <20090311.015542.118514963.ryusuke@osrg.net>
	<20090310174627.GA10667@silver.sucs.org>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 11 Mar 2009 03:54:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Tue, 10 Mar 2009 17:46:27 +0000, Sitsofe Wheeler wrote:
> Hello,
> 
> On Wed, Mar 11, 2009 at 01:55:42AM +0900, Ryusuke Konishi wrote:
> >  # lscp
> >  (list checkpoints)
> > 
> >             CNO        DATE     TIME  MODE  FLG   NBLKINC       ICNT
> >           33338  2009-03-08 14:45:49   cp    -         11          3
> >           33339  2009-03-08 14:50:22   cp    -     200523         81
> >           33340  2009-03-08 20:40:34   cp    -        136         61
> >           33341  2009-03-08 20:41:20   cp    -     187666       1604
> >           33342  2009-03-08 20:41:42   cp    -         51       1634
> >             ...
> 
> Is there a cheaty way to get at checkpointed files (and the list of
> checkpoints) through some sort of magic dot directory system (so you
> wouldn't need the userland tools and the remounting)?

No, we don't give the special namespace extension to nilfs2.

Instead, we have adopted out-of-filesystem solution, that is, using
autofs to present checkpoints on namespace outside nilfs.

Autofs is useful to presents many snapshots or checkpoints
automatically, and it allows flexible naming rules.

Maybe we can natively support the magic dot directory, and we may do
that if many users demand it or we confront some kind of scalability
issue.  But, so far it seems to work well enough.

Regards,
Ryusuke
