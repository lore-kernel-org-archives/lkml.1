Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432AbZF1V2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbZF1V2e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 17:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbZF1V2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 17:28:25 -0400
Received: from mail.samba.org ([66.70.73.150]:49939 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbZF1V2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 17:28:25 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19015.57452.966688.694057@samba.org>
Date: Mon, 29 Jun 2009 07:28:12 +1000
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: john.lanza@linux.com, linux-kernel@vger.kernel.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
In-Reply-To: <m1k52wxhki.fsf@fess.ebiederm.org>
References: <19013.8005.541836.436991@samba.org>
	<m1d48p5dil.fsf@fess.ebiederm.org>
	<19014.54044.484370.187018@samba.org>
	<m1vdmh2e26.fsf@fess.ebiederm.org>
	<19015.482.794111.612472@samba.org>
	<87ab3sx4ch.fsf@devron.myhome.or.jp>
	<m1k52wxhki.fsf@fess.ebiederm.org>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

 > Tridge.  Is there any reason to believe that Microsoft will continue
 > to treat Longfilenames without short filenames as valid in vfat?

I'd be quite surprised if they deliberately changed their VFAT code to
break Linux with this patch. I'd say it is more likely that once Linux
kernels with this change are in widespread use that Microsoft will
start to test any changes in their VFAT filesystem to make sure it
works with Linux with this patch.

 > It wouldn't even surprise me if you haven't seen such shenanigans
 > while working on samba.

In recent times Microsoft has been testing new OS releases against
Samba, and has been actively working with the Samba Team to try to
prevent breakages with new releases. That doesn't mean the scenario
you describe is impossible, it just means it isn't as likely as
perhaps it once was.

Cheers, Tridge
