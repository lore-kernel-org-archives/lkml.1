Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945AbYHYFdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbYHYFdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 01:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbYHYFdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 01:33:12 -0400
Received: from sh.osrg.net ([192.16.179.4]:46141 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbYHYFdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 01:33:11 -0400
Date: Mon, 25 Aug 2008 14:32:51 +0900
To: nix@esperi.org.uk
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, adobriyan@gmail.com
Subject: Re: Writable packet CD-RW mounting broken in 2.6.26 by your commit
 68154e90c9d1492d570671ae181d9a8f8530da55
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <871w0eb9nx.fsf@hades.wkstn.nix>
References: <8763pr1jy0.fsf_-_@hades.wkstn.nix>
	<20080824144827R.fujita.tomonori@lab.ntt.co.jp>
	<871w0eb9nx.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080825143125M.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Aug 2008 18:33:06 +0100
Nix <nix@esperi.org.uk> wrote:

> On 24 Aug 2008, FUJITA Tomonori spake thusly:
> > I think that I put a bug in bio_copy_kern(). Can you try this patch?
> 
> It works, I can back up again!

Thanks for testing.


> > I think that bio_uncopy_user has the same bug. I'll send a patch after
> > fixing this bug.
> 
> Great.
> 
> I suspect this is -stable material, right?

Yes, there are the same bugs in 2.6.26.

I added the Cc: stable tag on the patches so they will go to the
stable tree as soon as they get merged into mainline, I think.

Again, sorry about these bugs and thanks for the investigation.
