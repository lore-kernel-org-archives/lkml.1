Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbZBIRBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbZBIRBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbZBIRBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:01:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:35406 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932AbZBIRBb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:01:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,406,1231142400"; 
   d="scan'208";a="664085613"
From: "Brown, Len" <len.brown@intel.com>
To: Greg KH <gregkh@suse.de>, Arjan van de Ven <arjan@infradead.org>
CC: Stefan Lippers-Hollmann <s.L-H@gmx.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>
Date: Mon, 9 Feb 2009 10:00:10 -0700
Subject: RE: patch acpi-remove-locking-from-pm1x_sts-register-reads.patch
	added to 2.6.28-stable tree
Thread-Topic: patch acpi-remove-locking-from-pm1x_sts-register-reads.patch
	added to 2.6.28-stable tree
Thread-Index: AcmK1sEsqiehEiXrQCGavo3nioAjmQAAJTNg
Message-ID: <E87738D94A6AD54789B5B8D1BAEB06CC49F143F02E@azsmsx503.amr.corp.intel.com>
References: <20090208211932.4CAB349019@coco.kroah.org>
 <200902090124.44228.s.L-H@gmx.de> <20090209162402.GA13931@suse.de>
 <20090209083050.361e997d@infradead.org> <20090209164905.GA5420@suse.de>
In-Reply-To: <20090209164905.GA5420@suse.de>
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


>> why is this -stable material?
>> this is a performance improvement....
>
>It is, and not a bugfix?  If so, I'll drop it.

yes, removing the un-necessary locking
it is a scaling performance improvement.

The code has been this way for years.
The reason we noticed this issue recently
is because of the emergence of systems that
simultaneously have many threads and also
have deep C-states.

In 2.6.30 we plan larger improvements in this area.

cheers,
-Len
