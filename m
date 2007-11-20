Return-Path: <linux-kernel-owner+w=401wt.eu-S1760013AbXKTMuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013AbXKTMuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 07:50:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756807AbXKTMt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 07:49:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:36695 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756306AbXKTMt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 07:49:58 -0500
From: Andi Kleen <ak@suse.de>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Subject: Re: [patch][v2] x86, ptrace: support for branch trace store(BTS)
Date: Tue, 20 Nov 2007 13:45:39 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       akpm@linux-foundation.org
References: <029E5BE7F699594398CA44E3DDF55444F3AEA7@swsmsx413.ger.corp.intel.com>
In-Reply-To: <029E5BE7F699594398CA44E3DDF55444F3AEA7@swsmsx413.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711201345.39580.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> - the internal buffer interpretation as well as the corresponding
>   operations are selected at run-time by hardware detection
>   - different processors use different branch record formats

I still think it would be far better if you would switch this over to be table
driven. e.g. define a record that contains offsetof()/sizeof() of the 
different formats and use generic functions. That would decrease
code size considerably.

Also those manpages are really needed.

And your patch seems to be word wrapped.

-Andi
