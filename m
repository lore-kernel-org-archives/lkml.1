Return-Path: <linux-kernel-owner+w=401wt.eu-S1761245AbXKTPrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761245AbXKTPrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 10:47:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760870AbXKTPrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 10:47:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59863 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760839AbXKTPrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 10:47:35 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Subject: Re: [patch][v2] x86, ptrace: support for branch trace store(BTS)
Date: Tue, 20 Nov 2007 16:47:30 +0100
User-Agent: KMail/1.9.6
Cc: "dean gaudet" <dean@arctic.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       akpm@linux-foundation.org
References: <029E5BE7F699594398CA44E3DDF55444F3AEA7@swsmsx413.ger.corp.intel.com> <alpine.DEB.0.99999.0711200708580.765@twinlark.arctic.org> <029E5BE7F699594398CA44E3DDF55444F71257@swsmsx413.ger.corp.intel.com>
In-Reply-To: <029E5BE7F699594398CA44E3DDF55444F71257@swsmsx413.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711201647.30855.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> We might want to add support for Netburst in 64bit mode some day. 
> For today, I simply exclude Netburst for x86_64.

If you switched to table driven then adding another format like 
this would be likely very easy. It's just that with the "own code for everything"
method it becomes difficult.

-Andi
