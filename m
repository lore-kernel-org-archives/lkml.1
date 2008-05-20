Return-Path: <linux-kernel-owner+w=401wt.eu-S1761385AbYETDyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761385AbYETDyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 23:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757367AbYETDyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 23:54:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:5629 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757278AbYETDyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 23:54:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,513,1204531200"; 
   d="scan'208";a="283077995"
Subject: Re: [ipw3945-devel] ieee80211: unable to handle kernel NULL
	pointer dereference
From: Zhu Yi <yi.zhu@intel.com>
To: Alex Riesen <raa.lkml@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ipw3945-devel@lists.sourceforge.net
In-Reply-To: <81b0412b0805181323i5348b7fandaee5c3db001fa37@mail.gmail.com>
References: <81b0412b0805181323i5348b7fandaee5c3db001fa37@mail.gmail.com>
Content-Type: text/plain
Organization: Intel Corp.
Date: Tue, 20 May 2008 11:54:09 +0800
Message-Id: <1211255649.7814.9.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-05-18 at 22:23 +0200, Alex Riesen wrote:
> May 18 18:59:24 blimp kernel: RIP  [ieee80211_associate+0x2a0/0x536]
> ieee80211_associate+0x2a0/0x536
> May 18 18:59:24 blimp kernel:  RSP <ffff81007f261b20>
> May 18 18:59:24 blimp kernel: CR2: 00000000000000c0
> May 18 18:59:24 blimp kernel: ---[ end trace 0fbf8adf45e059dd ]---

This is a known mac80211 bug. The fix (might not be the final one) is
here:
http://marc.info/?l=linux-wireless&m=121120929012836&w=2

Thanks,
-yi

