Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbZKMORr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbZKMORr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 09:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbZKMORo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 09:17:44 -0500
Received: from smtp.nokia.com ([192.100.122.233]:44075 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbZKMORn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 09:17:43 -0500
Subject: Re: [PATCH, RFC] panic-note: Annotation from user space for panics
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: David VomLehn <dvomlehn@cisco.com>,
       Marco Stornelli <marco.stornelli@gmail.com>,
       linux-embedded@vger.kernel.org, akpm@linux-foundation.org,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org, mpm@selenic.com,
       paul.gortmaker@windriver.com,
       "Shargorodsky Atal (EXT-Teleca/Helsinki)" 
	<ext-atal.shargorodsky@nokia.com>
In-Reply-To: <20091113125946.5353164c@marrow.netinsight.se>
References: <20091112021322.GA6166@dvomlehn-lnx2.corp.sa.net>
	 <4AFC4D31.2000101@gmail.com>
	 <20091112215649.GA28349@dvomlehn-lnx2.corp.sa.net>
	 <20091113091031.3f6d4bba@marrow.netinsight.se>
	 <1258112748.21596.1227.camel@localhost>
	 <20091113125946.5353164c@marrow.netinsight.se>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Nov 2009 16:16:53 +0200
Message-Id: <1258121813.21596.1229.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 Nov 2009 14:16:59.0567 (UTC) FILETIME=[F6A383F0:01CA646B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-13 at 12:59 +0100, Simon Kagstrom wrote:
> (Also fix David Woodhouses address and add Atal)
> 
> On Fri, 13 Nov 2009 13:45:48 +0200
> Artem Bityutskiy <dedekind1@gmail.com> wrote:
> 
> > So we really need to print some user-space supplied information during
> > the panic, and then we store it on flash with mtdoops, and the later,
> > when the device has network access we send whole bunch of oopses via the
> > network.
> 
> Yes, I see that your case would have to be handled differently. A
> complication (which I believe was discussed before) is that kmsg_dump()
> is done before the panic notifiers are called.
> 
> The reason I put it there is to have it before crash_kexec(), so I
> guess we'll have to take up the discussion on what to do with it. For
> me it now seems like it would be OK to move kmsg_dump() down below the
> panic notifiers.
> 
> If you have a kdump kernel to load, then you will most likely not need
> the kmsg dumped data anyway.

Yeah, I think this is a separate issue which can be fixed separately.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

