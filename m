Return-Path: <linux-kernel-owner+w=401wt.eu-S1765553AbYEFQnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765553AbYEFQnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765663AbYEFQmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:42:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:62653 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763822AbYEFQmf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:42:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,444,1204531200"; 
   d="scan'208";a="380587134"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 1/8] Scaling msgmni to the amount of lowmem
Date: Tue, 6 May 2008 09:42:25 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843EC014392F9@orsmsx424.amr.corp.intel.com>
In-Reply-To: <481EC917.6070808@bull.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/8] Scaling msgmni to the amount of lowmem
Thread-Index: AciujFpup9PIr2A3RmCHKO8XqeUP5wBCuVpg
References: <20080211141646.948191000@bull.net>	 <20080211141813.354484000@bull.net> <12c511ca0804291328v2f0b87csd0f2cf3accc6ad00@mail.gmail.com> <481EC917.6070808@bull.net>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Nadia Derbey" <Nadia.Derbey@bull.net>
Cc: <linux-kernel@vger.kernel.org>, <y-goto@jp.fujitsu.com>,
       <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
       <containers@lists.linux-foundation.org>, <matthltc@us.ibm.com>,
       <cmm@us.ibm.com>
X-OriginalArrivalTime: 06 May 2008 16:42:26.0603 (UTC) FILETIME=[2AAE87B0:01C8AF98]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, this printk had been suggested by somebody (sorry I don't remember 
> who) when I first submitted the patch. Actually I think it might be 
> useful for a sysadmin to be aware of a change in the msgmni value: we 
> have the message not only at boot time, but also each time msgmni is 
> recomputed because of a change in the amount of memory.

If the message is directed at the system administrator, then it would
be nice if there were some more meaningful way to show the namespace
that is affected than just printing the hex address of the kernel structure.

As the sysadmin for my test systems, printing the hex address is mildly
annoying ... I now have to add a new case to my scripts that look at
dmesg output for unusual activity.

Is there some better "name for a namespace" than the address? Perhaps
the process id of the process that instantiated the namespace???

-Tony
