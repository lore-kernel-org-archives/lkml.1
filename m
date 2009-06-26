Return-Path: <linux-kernel-owner+w=401wt.eu-S1754111AbZFZWVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbZFZWVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 18:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbZFZWVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 18:21:13 -0400
Received: from mail.samba.org ([66.70.73.150]:53350 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbZFZWVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 18:21:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19013.18894.749105.721881@samba.org>
Date: Sat, 27 Jun 2009 08:21:02 +1000
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
In-Reply-To: <4A45405A.1010404@zytor.com>
References: <19013.8005.541836.436991@samba.org>
	<4A45405A.1010404@zytor.com>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hpa wrote:
 > However, as such it really should be paired with a "don't even recognize
 > the shortname if a longname exists" option.

Right, we could just skip the 8.3 name matching and go straight to the
longname match in fat_search_long(). I wonder if anyone ever relies on
the 8.3 matching when a file has a long name on Linux?

 > It's also questionable IMO if this shouldn't be another FAT superdriver,
 > just as we have VFAT, MS-DOS etc. we could have "purevfat".

It would be only a few lines of code difference between the two
drivers - is it worth the maintainence overhead of splitting it up?

Maybe a mount option to ignore 8.3 names for files with long names
would be better? Perhaps even the default?

Cheers, Tridge
