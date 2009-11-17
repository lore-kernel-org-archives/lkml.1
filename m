Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbZKRAGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbZKRAGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 19:06:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbZKRAGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 19:06:02 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:44450 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbZKRAGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 19:06:01 -0500
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Nov 2009 19:06:01 EST
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAGbGAkurRN+K/2dsb2JhbAC+P5hBhDsE
X-IronPort-AV: E=Sophos;i="4.44,761,1249257600"; 
   d="scan'208";a="50744639"
Date: Tue, 17 Nov 2009 18:56:27 -0500
From: David VomLehn <dvomlehn@cisco.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: dedekind1@gmail.com, Marco Stornelli <marco.stornelli@gmail.com>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       linux-embedded@vger.kernel.org, akpm@linux-foundation.org,
       dwm2@infradead.org, linux-kernel@vger.kernel.org, mpm@selenic.com,
       paul.gortmaker@windriver.com
Subject: Re: [PATCH, RFC] panic-note: Annotation from user space for panics
Message-ID: <20091117235627.GA13469@dvomlehn-lnx2.corp.sa.net>
References: <1258463404.27437.103.camel@localhost> <m1pr7hf93s.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1pr7hf93s.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 10:45:43AM -0500, Eric W. Biederman wrote:
...
> Why not use the kdump hook?  If you handle a kernel panic that way
> you get enhanced reliability and full user space support.  All in a hook
> that is already present and already works.

I'm a big fan of avoiding reinvention of the wheel--if I can use something
already present, I will. However, I'm not clear about how much of the problem
I'm addressing will be solved by using a kdump hook. If I understand
correctly, you'd still need a pseudo-file somewhere to actually get the data
from user space to kernel space. *Then* you could use a kdump hook to
transfer the data to flash or some memory area that will be retained across
boots. Is this the approach to which you were referring? If so, I have a
couple more questions:

1. In what ways would this be better than, say, a panic_notifier?
2. Where would you suggest tying in? (Particularly since not all architectures
   currently support kdump)

> Eric

David VL
