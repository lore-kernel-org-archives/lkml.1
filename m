Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbZKQIx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbZKQIx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 03:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbZKQIx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 03:53:58 -0500
Received: from smtp.nokia.com ([192.100.122.233]:25900 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbZKQIx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 03:53:57 -0500
Subject: Re: [PATCH, RFC] panic-note: Annotation from user space for panics
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>,
       David VomLehn <dvomlehn@cisco.com>, linux-embedded@vger.kernel.org,
       akpm@linux-foundation.org, dwm2@infradead.org,
       linux-kernel@vger.kernel.org, mpm@selenic.com,
       paul.gortmaker@windriver.com
In-Reply-To: <4AFE6A14.4010507@gmail.com>
References: <20091112021322.GA6166@dvomlehn-lnx2.corp.sa.net>
	 <4AFC4D31.2000101@gmail.com>
	 <20091112215649.GA28349@dvomlehn-lnx2.corp.sa.net>
	 <20091113091031.3f6d4bba@marrow.netinsight.se>
	 <1258112748.21596.1227.camel@localhost>  <4AFE6A14.4010507@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Nov 2009 10:53:17 +0200
Message-Id: <1258447997.27437.76.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 17 Nov 2009 08:53:24.0490 (UTC) FILETIME=[6C00DEA0:01CA6763]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marko,

On Sat, 2009-11-14 at 09:28 +0100, Marco Stornelli wrote:
> I think in general the procedure should be: at startup or event (for
> example acquired IP address from DHCP) user applications write in flash
> (better in persistent ram) a log with a tag or a timestamp or something
> like this, when there is a kernel panic, it is captured in a file stored
> together the log and when possible the system should send all via
> network for example. Are there problems that I can't see to follow this
> approach? When David says "...so this looks much more like a real file
> than a sysctl file" I quite agree, it seems a normal application/system
> log indeed.

Please, do not top-post, you make it difficult to discuss things by
messing up the context. Be consistent with how other people reply in
this thread, please.

Take a look at my mails where I describe different complications we have
in our system. We really want to have an OOPS/panic + our environment
stuff to go together, at once. This makes things so much simpler.

Really, what is the problem providing this trivial panic-note
capability, where user-space can give the kernel a small buffer, and ask
the kernel to print this buffer at the oops/panic time. Very simple and
elegant, and just solves the problem.

Why perversions with time-stamps, separate storages are needed?

IOW, you suggest a complicated approach, and demand explaining why we do
not go for it. Simply because it is unnecessarily complex. This patch
solves the problem gracefully, and I'd rather demand you to point what
is the technical problem with the patches.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

