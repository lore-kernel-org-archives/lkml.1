Return-Path: <linux-kernel-owner+w=401wt.eu-S936843AbXHIEwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936843AbXHIEwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 00:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbXHIEwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 00:52:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56697 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbXHIEwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 00:52:18 -0400
Date: Thu, 9 Aug 2007 13:53:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "tony.luck@intel.com" <tony.luck@intel.com>, davem@davemloft.net,
       "Zoltan.Menyhart@bull.net" <Zoltan.Menyhart@bull.net>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "kamezawa.hiroyu@jp.fujitsu.com" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH] flush icache before set_pte() on ia64  take9 [0/2] all
 renewed
Message-Id: <20070809135311.0676a947.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

synching Icache and Dcache before set_pte() for ia64 take9.

take8 got negative review as "ia64 specific codes are scattered over vm layer
and it will not be able to be maintained." And adivce from David Miller (thanks!)
was modifiying set_pte().

This version modifies set_pte() for inserting "ia64 specific" flush cache code.
It seems that I encoded all conditions for flush_icache necessity in clear way
and the whole code is not invasive.

Any comments are welcome.

Thanks,
-Kame


