Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbZCEWic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbZCEWic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 17:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbZCEWiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 17:38:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:57862 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbZCEWiX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 17:38:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,309,1233561600"; 
   d="scan'208";a="670715259"
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: Maurice Volaski <mvolaski@aecom.yu.edu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Date: Thu, 5 Mar 2009 14:38:13 -0800
Subject: RE: e1000 is subtly incompatible with jumbo frames
Thread-Topic: e1000 is subtly incompatible with jumbo frames
Thread-Index: Acmd3/YFjEAc/yCKQ6KEQPmhERTXBAAAu9LQ
Message-ID: <F169D4F5E1F1974DBFAFABF47F60C10A1E6EABF2@orsmsx507.amr.corp.intel.com>
References: <a06240409c5d5e74a49d0@[129.98.90.227]>
In-Reply-To: <a06240409c5d5e74a49d0@[129.98.90.227]>
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

Maurice Volaski wrote:
> I have a system using the e1000 driver with the MTU set to 9000. If I
> try FTP to get a file, the transfer does not start. Something about
> the 9000 MTU is preventing the NIC from receiving packets back from
> the FTP server. (The FTP server is on the same subnet and its NIC
> also has MTU 9000.) The 9000 MTU NIC works fine in every other
> respect, even allowing me to access the system via ssh. When I change
> the MTU to 1500, then FTP works fine. The problem is common to
> numerous kernel versions including 2.6.24 through 2.6.29-rc5.

This sounds like you have not configured the MTU the same on both ends
or some station in between is having issues with the large packets

please double check your configuration.

we also need to know kernel version, driver version, lspci output

Thanks,
  Jesse