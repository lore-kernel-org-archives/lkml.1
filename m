Return-Path: <linux-kernel-owner+w=401wt.eu-S1761381AbZCNCFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761381AbZCNCFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 22:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756153AbZCNBWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:22:14 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:65159 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755868AbZCNBV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:21:56 -0400
To: jesse.brandeburg@intel.com, greg@kroah.com, akpm@linux-foundation.org
Cc: e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       stable@kernel.org, netdev@vger.kernel.org
Subject: Re: [E1000-devel] [stable] Li-nux 2.6.27.19  2.6.28.7
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20090220225448.GA14122@kroah.com>
	<20090313151051.a9198384.akpm@linux-foundation.org>
	<20090313222044.GA18010@kroah.com>
	<F169D4F5E1F1974DBFAFABF47F60C10A1E80D63A@orsmsx507.amr.corp.intel.com>
In-Reply-To: <F169D4F5E1F1974DBFAFABF47F60C10A1E80D63A@orsmsx507.amr.corp.intel.com>
Message-Id: <200903141021.BAI56205.QtLOFJOFOHMFSV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 14 Mar 2009 10:21:51 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Brandeburg, Jesse wrote:
> Greg KH wrote:
> > On Fri, Mar 13, 2009 at 03:10:51PM -0700, Andrew Morton wrote:
> >> 
> >> I fired up this kernel up on my FC8 laptop and I see
> >> http://userweb.kernel.org/~akpm/p3130212.jpg
> >> 
> >> On the next two boot attempts, the kernel came up OK.
> >> 
That picture may be caused by /dev/root being automatically disappeared.
https://bugzilla.redhat.com/show_bug.cgi?id=488679

> root issue:
> seems that something with the 2.6.newer doesn't like some of the stuff with the fedora nash stuff.
> mkinitrd and friends were updated multiple times to work with these newer kernels in the fedora 10
> I was using.  I worked around by changing root=LABEL to use root=/dev/foo in grub.conf

I don't experience this problem with Debian Sarge.
I think it is Fedora's nash problem.
