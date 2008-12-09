Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbYLISvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbYLISvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 13:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbYLISvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 13:51:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:8350 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483AbYLISvH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 13:51:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,743,1220252400"; 
   d="scan'208";a="472503099"
From: "Luck, Tony" <tony.luck@intel.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Date: Tue, 9 Dec 2008 10:50:56 -0800
Subject: RE: next-20081104 - kernel panic on ia64 box, at
	__mutex_lock_interruptible_slowpath
Thread-Topic: next-20081104 - kernel panic on ia64 box, at
	__mutex_lock_interruptible_slowpath
Thread-Index: AclZzQOPncGz+fh6TEGiZ1760e+B5AAYdB/A
Message-ID: <57C9024A16AD2D4C97DC78E552063EA35C7EEAA3@orsmsx505.amr.corp.intel.com>
References: <20081204200745.eff0ac87.sfr@canb.auug.org.au>
 <20081209070730.GA12102@linux.vnet.ibm.com>
In-Reply-To: <20081209070730.GA12102@linux.vnet.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>       next-20081204 kernel panic's, while booting up on ia64 box. This panic
> was not reproducible with the latest next-20081208 kernel.

I saw that too ... it was preceeded by an "impossible" WARN_ON message,
so I put it down to some experimental/untested code in linux-next.

-Tony
