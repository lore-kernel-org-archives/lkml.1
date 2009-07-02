Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbZGBXJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbZGBXJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 19:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZGBXJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 19:09:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:46919 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbZGBXJG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 19:09:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,337,1243839600"; 
   d="scan'208";a="471640405"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Pavel Machek <pavel@ucw.cz>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Date: Thu, 2 Jul 2009 16:09:09 -0700
Subject: RE: [PATCH 2/9] x86: introduce a set of platform feature flags
Thread-Topic: [PATCH 2/9] x86: introduce a set of platform feature flags
Thread-Index: Acn6Knv4XHqeI486RqmNZq950/cs2gBPsvAw
Message-ID: <43F901BD926A4E43B106BF17856F07556428B555@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F07556412B7E1@orsmsx508.amr.corp.intel.com>
 <20090630063230.GD1351@ucw.cz>
In-Reply-To: <20090630063230.GD1351@ucw.cz>
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

>> +#define platform_has(bit) \
>> +	test_bit(bit, (unsigned long *)platform_feature)
>
>test_bit and friends imply synchronization you probably  don't want or
>need...
>
[[JPAN]] could you explain a little more? The disassembly shows the test_bit
ends up as a testb instruction and a jump. Why there is synchronization
 involved?
Perhaps on some architectures?
