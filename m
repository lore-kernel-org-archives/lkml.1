Return-Path: <linux-kernel-owner+w=401wt.eu-S1758019AbXIRAQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019AbXIRAQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 20:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756419AbXIRAQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 20:16:29 -0400
Received: from vsmtp03.dti.ne.jp ([202.216.231.138]:62607 "EHLO
	vsmtp03.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079AbXIRAQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 20:16:29 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [PATCH] ext34: ensure do_split leaves enough free space in both blocks 
To: Andrew Morton <akpm@linux-foundation.org>,
       Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>,
       ext4 development <linux-ext4@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Theodore Ts'o" <tytso@mit.edu>
In-Reply-To: <20070917205738.GQ2990@schatzie.adilger.int>
References: <46EEA5F4.3030806@redhat.com> <46EEB7A4.9040903@sandeen.net> <20070917133020.5fc4650c.akpm@linux-foundation.org> <20070917205738.GQ2990@schatzie.adilger.int>
Date: Tue, 18 Sep 2007 09:16:08 +0900
Message-Id: <E1IXQl6-0000wx-6U@jroun>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Andreas Dilger:
> > So this looks like 2.6.22 and 2.6.23 material, but the timing is getting
> > pretty squeezy.  Could people please give this change an extra-close
> > review, let me know?
> 
> I already discussed it at length with Eric and inspected the patch, so we
> could add:
> Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
> 
> Haven't actually tested the code myself.

I've just tested the patch on linux-2.6.23-rc6 (i386) with the test
program I posted a few months ago, and found it solved the problem.
Thank you very much Eric Sandeen, Andreas Dilger and all in ML.

Junjiro Okajima
