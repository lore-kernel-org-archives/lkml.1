Return-Path: <linux-kernel-owner+w=401wt.eu-S1760187AbZKFX6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187AbZKFX6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 18:58:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759052AbZKFX6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 18:58:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:61293 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbZKFX6G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 18:58:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,696,1249282800"; 
   d="scan'208";a="744636094"
From: "Tantilov, Emil S" <emil.s.tantilov@intel.com>
To: Nix <nix@esperi.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Date: Fri, 6 Nov 2009 16:58:09 -0700
Subject: RE: [E1000-devel] [in-tree drivers] freezing e1000e in 2.6.31 (SMP
	only? MSI?)
Thread-Topic: [E1000-devel] [in-tree drivers] freezing e1000e in 2.6.31 (SMP
	only? MSI?)
Thread-Index: AcpfKA+FkcyPap9ySF6aivcRYO3zdwAE3kAg
Message-ID: <EA929A9653AAE14F841771FB1DE5A1365F9923A504@rrsmsx501.amr.corp.intel.com>
References: <873a4rqu9o.fsf@spindle.srvr.nix>
In-Reply-To: <873a4rqu9o.fsf@spindle.srvr.nix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nix wrote:
> Ever since 2.6.31 was released, my gigabit e1000e link has been acting
> up. Notably, under sufficient load (generally, on this machine, NFS
> load), packets cease to be transferred, and the (MSI) interrupt count
> ceases to rise. Pulling the interface down and bringing it back up
> works, both via ip(8) and by simply yanking the cable and plugging it
> in again.

Can you please send the output of ethtool -S from the interface after you observe the failure?

Also try disabling Tx pause frames:
ethtool -A fastnet tx off autoneg off

and let me know if that fixes it for you.

Thanks,
Emil