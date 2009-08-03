Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbZHCRx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbZHCRx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 13:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbZHCRx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 13:53:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:64650 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963AbZHCRx2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 13:53:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,315,1246863600"; 
   d="scan'208";a="171797095"
From: "Othman, Ossama" <ossama.othman@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 3 Aug 2009 10:53:27 -0700
Subject: RE: [PATCH] Moorestown RAR Handler driver, MRST 2.6.31-rc3
Thread-Topic: [PATCH] Moorestown RAR Handler driver, MRST 2.6.31-rc3
Thread-Index: AcoUYjy49UGMcHxdRCijAYJLz/9eZgAALoxg
Message-ID: <A5FE05C4C76E4C4CAB15D9962B96FC950C7957A892@orsmsx510.amr.corp.intel.com>
References: <1249082419-27718-1-git-send-email-ossama.othman@intel.com>
	 <20090801073053.GA30389@merkur.ravnborg.org>
	 <A5FE05C4C76E4C4CAB15D9962B96FC950C7957A872@orsmsx510.amr.corp.intel.com>
 <1249321533.5149.21.camel@Joe-Laptop.home>
In-Reply-To: <1249321533.5149.21.camel@Joe-Laptop.home>
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

>> >It is recommended to separate definition,
>> >and assignment.
>> >So this should look like this:
>> >	struct memrar_allocator *allocator;
>> >	allocator = 0;
>> Okay, I'll fix that, too.  Should this go into Documentation/CodingStyle,
>too?
>
>I don't agree with that at all, neither does a lot of the kernel source.
>
>Automatic structs with initializers:
>$ grep -rP --include=*.c "^\s+struct\s+\w+\s*\*\s*\w+\s*=\s*\w+\s*;" * | wc
>-l
>9498
>
>I think it should be struct memrar_allocator *allocator = NULL;

Got it.  I've already started changing all zero pointer initializations to NULL instead.  I'll also leave the declaration and initialization on the same line for now.

Thanks again!
-Ossama
