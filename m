Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbYKTAC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbYKTAC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 19:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbYKTACT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 19:02:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:63966 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbYKTACS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 19:02:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,635,1220252400"; 
   d="scan'208";a="362112138"
From: "Zou, Yi" <yi.zou@intel.com>
To: David Miller <davem@davemloft.net>
CC: "jeff@garzik.org" <jeff@garzik.org>,
       "linux-netdev@vger.kernel.org" <linux-netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 19 Nov 2008 16:02:03 -0800
Subject: RE: [PATCH 3/3] net: define feature flags for FCoE offloads
Thread-Topic: [PATCH 3/3] net: define feature flags for FCoE offloads
Thread-Index: AclKoTHwphYlHGUQTEWuc/CoK+NrvQAADVCw
Message-ID: <1DB50624F8348F48840F2E2CF6040A9D2F383FB5@orsmsx508.amr.corp.intel.com>
References: <20081117182659.15776.58181.stgit@zychongqing.jf.intel.com>
	<20081117183049.15776.84674.stgit@zychongqing.jf.intel.com>
 <20081119.154710.135220757.davem@davemloft.net>
In-Reply-To: <20081119.154710.135220757.davem@davemloft.net>
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

>From: David Miller [mailto:davem@davemloft.net]
>Sent: Wednesday, November 19, 2008 3:47 PM
>
>
>Why would FibreChannel over Ethernet need IPV4/IPV6 segmentation
>offloading?
Thanks for reviewing the patch. I am hoping to make use of the existing gso logic as much as possible for fcoe segmentation as well, to hookup fcoe segmentation using ptype->gso_segment(). 

Thanks.

yi

