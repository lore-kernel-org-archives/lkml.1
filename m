Return-Path: <linux-kernel-owner+w=401wt.eu-S1752234AbZF2BYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbZF2BYX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 21:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbZF2BYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 21:24:12 -0400
Received: from mail.samba.org ([66.70.73.150]:57070 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbZF2BYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 21:24:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19016.6052.681949.872870@samba.org>
Date: Mon, 29 Jun 2009 11:23:48 +1000
To: Jamie Lokier <jamie@shareable.org>
Cc: Jan Engelhardt <jengelh@medozas.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
In-Reply-To: <20090628215754.GA29896@shareable.org>
References: <19013.8005.541836.436991@samba.org>
	<alpine.LSU.2.00.0906271918280.5582@fbirervta.pbzchgretzou.qr>
	<19014.56477.311713.975403@samba.org>
	<20090628215754.GA29896@shareable.org>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jamie,

 > For those of us who don't want to omit the code, because we like
 > compatibility and we're not in affected countries, or for research, it
 > would be useful to have it as a mount option.

For research I think having to recompile the module is not a big
burden.

The compatibility argument is more debatable, and if the patch
involved the loss of a large degree of functionality then I would
probably agree. As it is, the patch loses very little functionality -
it is hard to find real scenarios where not storing a 8.3 name along
with the long name will actually cause any problems.

I also don't think it is worth having a different kernel in different
countries for this change, again because the loss of functionality is
so small. The relevant patents exist in several countries (in various
forms), and while the US might be the country of choice for enforcing
patents it is not the only country where patents are a concern.

I would rather see us err on the side of caution and ensure that
Microsoft is not left with an opportunity to continue to spread FUD
about Linux with regards to these patents.

Cheers, Tridge
