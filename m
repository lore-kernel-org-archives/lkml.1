Return-Path: <linux-kernel-owner+w=401wt.eu-S1758751AbYFXR4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751AbYFXR4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 13:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbYFXR4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 13:56:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:56072 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902AbYFXR42 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 13:56:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,697,1204531200"; 
   d="scan'208";a="299065068"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>, Julia Lawall <julia@diku.dk>,
       "akinobu.mita@gmail.com" <akinobu.mita@gmail.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Tue, 24 Jun 2008 10:56:19 -0700
Subject: RE: [PATCH 3/14] arch/ia64: Eliminate NULL test and memset after
 alloc_bootmem
Thread-Topic: [PATCH 3/14] arch/ia64: Eliminate NULL test and memset after
 alloc_bootmem
Thread-Index: AcjV02r92Re9xBMoSreFnBqpQcF2TAATd5jgAAB+0NA=
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3062D2476@orsmsx505.amr.corp.intel.com>
References: <Pine.LNX.4.64.0806241021360.26777@ask.diku.dk>
 <57C9024A16AD2D4C97DC78E552063EA3062D2438@orsmsx505.amr.corp.intel.com>
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3062D2438@orsmsx505.amr.corp.intel.com>
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

> In addition the current alloc_bootmem() is a macro that uses __alloc_bootmem
> which most defintely can return NULL.

        ...
        panic("Out of memory");
        return NULL;
}

Oops ... that "panic" call before the "return NULL" makes the
above statement totally wrong.

-Tony
