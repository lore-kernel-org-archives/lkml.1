Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbZKWSDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbZKWSDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 13:03:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbZKWSDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 13:03:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:39663 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbZKWSDJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 13:03:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,273,1257148800"; 
   d="scan'208";a="572329128"
From: "Tantilov, Emil S" <emil.s.tantilov@intel.com>
To: David Miller <davem@davemloft.net>, "rjw@sisk.pl" <rjw@sisk.pl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-testers@vger.kernel.org" <kernel-testers@vger.kernel.org>,
       "skraw@ithnet.com" <skraw@ithnet.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Mon, 23 Nov 2009 11:02:43 -0700
Subject: RE: [Bug #14252] WARNING: at include/linux/skbuff.h:1382 w/ e1000
Thread-Topic: [Bug #14252] WARNING: at include/linux/skbuff.h:1382 w/ e1000
Thread-Index: AcppU+/fhI+Uv1k0TzmEy/q7I6E+bwDEUEfA
Message-ID: <EA929A9653AAE14F841771FB1DE5A1365FA6A95F33@rrsmsx501.amr.corp.intel.com>
References: <ipicVA1QUFF.A.zWB.1mdALB@chimera>
	<OWmO9uyC1hM.A.w9C.NodALB@chimera>
 <20091119.120721.252464351.davem@davemloft.net>
In-Reply-To: <20091119.120721.252464351.davem@davemloft.net>
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

David Miller wrote:
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Tue, 17 Nov 2009 00:01:18 +0100 (CET)
> 
>> This message has been generated automatically as a part of a report
>> of regressions introduced between 2.6.30 and 2.6.31.
>> 
>> The following bug entry is on the current list of known regressions
>> introduced between 2.6.30 and 2.6.31.  Please verify if it still
>> should be listed and let me know (either way).
>> 
>> 
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14252
>> Subject		: WARNING: at include/linux/skbuff.h:1382 w/ e1000
>> Submitter	: Stephan von Krawczynski <skraw@ithnet.com>
>> Date		: 2009-09-20 11:26 (58 days old)
>> References	: http://marc.info/?l=linux-kernel&m=125344599006033&w=4
> 
> Please CC: netdev when reporting networking problems, thank you.
> 
> Intel folks can you please take a look at this?  Thanks.

I have not been able to reproduce this issue so far. I don't have the exact same HW, but I tested on stock 2.6.31 with 82541 based NIC. More than 3 days now of stress without a problem.

If the reporter can provide some additional information that may be of help:
1. cat /proc/interrupts
2. ethtool -i ethX (where ethX is the interface that is causing the problem
3. lspci -vvv
4. ethtool -e ethX
5. specific settings that may deviate from the default configuration (like MTU)
6. type of traffic that is causing the issue.

Thanks,
Emil