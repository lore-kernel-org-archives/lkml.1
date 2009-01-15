Return-Path: <linux-kernel-owner+w=401wt.eu-S1760610AbZAODXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760610AbZAODXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 22:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbZAODW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 22:22:59 -0500
Received: from ozlabs.org ([203.10.76.45]:34453 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbZAODW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 22:22:58 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: regarding the x86_64 zero-based percpu patches
Date: Thu, 15 Jan 2009 12:17:53 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, travis@sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, steiner@sgi.com,
       Hugh Dickins <hugh@veritas.com>
References: <49649814.4040005@kernel.org> <m1k58zx305.fsf@frodo.ebiederm.org> <496D6300.9070402@kernel.org>
In-Reply-To: <496D6300.9070402@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901151217.54989.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 January 2009 14:28:56 Tejun Heo wrote:
> The main problem is that the area needs to be congruent which
> basically mandates them to be contiguous.

I want to explore this assumption a little.  Logically, yes, if 50% of pages are free and we have 4096 cpus, the chance that a page is free on all CPUs is 1 in 2^4095.  But maybe such systems are fine with 2M pages for per-cpu areas at boot?  And can page mobility tricks help us make the odds reasonable here?
Only allowing movable pages in our expansion-of-percpu area?

Thanks,
Rusty.
