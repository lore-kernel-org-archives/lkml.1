Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbZKLWJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbZKLWJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 17:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754371AbZKLWJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 17:09:19 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:39513 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbZKLWJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 17:09:19 -0500
Authentication-Results: sj-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAFUW/EqrRN+K/2dsb2JhbADFJJgahDwE
X-IronPort-AV: E=Sophos;i="4.44,731,1249257600"; 
   d="scan'208";a="223840424"
Date: Thu, 12 Nov 2009 17:09:25 -0500
From: David VomLehn <dvomlehn@cisco.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-embedded@vger.kernel.org, akpm@linux-foundation.org,
       dwm2@infradead.org, linux-kernel@vger.kernel.org, mpm@selenic.com
Subject: Re: [PATCH, RFC] panic-note: Annotation from user space for panics
Message-ID: <20091112220925.GC28349@dvomlehn-lnx2.corp.sa.net>
References: <20091112021322.GA6166@dvomlehn-lnx2.corp.sa.net> <4AFC6711.1090405@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFC6711.1090405@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 02:50:41PM -0500, Paul Gortmaker wrote:
> David VomLehn wrote:
>> Allows annotation of panics to include platform information. It's no big
>> deal to collect information, but way helpful when you are collecting
>> failure reports from a eventual base of millions of systems deployed in
>> other people's homes.
...
> Why hook into panic() directly like this, vs. using the panic
> notifier list? If you use that, and then put the data handling
> magic that you need into your own kernel module that knows how
> to interface with the reporting apps that you have, you can
> do the whole thing without having to alter existing code, I think.

I agree--a panic notifier list is probably a better approach.

David VL
