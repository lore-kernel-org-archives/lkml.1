Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbYEPBgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbYEPBgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 21:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbYEPBgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 21:36:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:43642 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbYEPBgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 21:36:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,494,1204531200"; 
   d="scan'208";a="282002936"
Subject: Re: [PATCH] kexec based hibernation: a prototype of kexec
	multi-stage load
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <m1lk2bs970.fsf@frodo.ebiederm.org>
References: <1210574441.30365.8.camel@caritas-dev.intel.com>
	 <20080513053408.GA5870@redhat.com>
	 <1210730266.23707.50.camel@caritas-dev.intel.com>
	 <20080514025607.GA19944@redhat.com>
	 <1210736275.23707.62.camel@caritas-dev.intel.com>
	 <m1lk2c4l4i.fsf@frodo.ebiederm.org>
	 <1210827473.23707.133.camel@caritas-dev.intel.com>
	 <m1lk2bs970.fsf@frodo.ebiederm.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 16 May 2008 09:41:54 +0800
Message-ID: <1210902114.23707.156.camel@caritas-dev.intel.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 16 May 2008 01:35:45.0256 (UTC) FILETIME=[29153E80:01C8B6F5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-15 at 11:39 -0700, Eric W. Biederman wrote:
[...]
> 2) After we figure out our address read the stack pointer from
>    a fixed location and simply set it.  (This is my preference)

Just for confirmation (My English is poor).

Do you mean that kernel A just read the stack top as re-entry point,
regardless of whether it is return address or argument 1?

Best Regards,
Huang Ying

