Return-Path: <linux-kernel-owner+w=401wt.eu-S1752893AbZHCRfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbZHCRfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 13:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbZHCRfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 13:35:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:18405 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbZHCRfR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 13:35:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,315,1246863600"; 
   d="scan'208";a="713508113"
From: "Othman, Ossama" <ossama.othman@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 3 Aug 2009 10:35:17 -0700
Subject: RE: [PATCH] Moorestown RAR Handler driver, MRST 2.6.31-rc3
Thread-Topic: [PATCH] Moorestown RAR Handler driver, MRST 2.6.31-rc3
Thread-Index: AcoSfop6RY6gEo5oRqynri/SclzkNQB4eZug
Message-ID: <A5FE05C4C76E4C4CAB15D9962B96FC950C7957A875@orsmsx510.amr.corp.intel.com>
References: <1249082419-27718-1-git-send-email-ossama.othman@intel.com>
	 <20090801073053.GA30389@merkur.ravnborg.org>
 <1249113782.27999.14.camel@Joe-Laptop.home>
In-Reply-To: <1249113782.27999.14.camel@Joe-Laptop.home>
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

Hi Joe,

>On Sat, 2009-08-01 at 09:30 +0200, Sam Ravnborg wrote:
>> Try to avoid breaking your printable line.
>> It is much easier to grep for the line when it is on a single
>> line.
>> If you violate the 80 chars per line rule do to this then accept
>> that grepable lines is better than keeping them 80 or less wide.
>
>Maybe it's better to ignore the indent guideline here as well.
>An outdent might be preferable to having the line exceed 80 chars.
>
>Maybe:
>		WARN(capacity < block_size * 2,
>	"Memory allocator is only large enough to hold one block.\n");
>or
>		WARN(capacity < block_size * 2,
>"Memory allocator is only large enough to hold one block.\n");

Okay, I'll see what I can do improve the readability and grep-ability of these log messages.

>Any format string longer than 80 chars is likely a poor log entry.

Agreed!

Thanks Joe!
-Ossama
