Return-Path: <linux-kernel-owner+w=401wt.eu-S1753794AbYLTLaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbYLTLaK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 06:30:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbYLTL35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 06:29:57 -0500
Received: from ozlabs.org ([203.10.76.45]:58327 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbYLTL34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 06:29:56 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 3/8] cpumask: convert kernel time functions
Date: Sat, 20 Dec 2008 21:59:52 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
References: <20081219160144.697518000@polaris-admin.engr.sgi.com> <20081219160145.144162000@polaris-admin.engr.sgi.com>
In-Reply-To: <20081219160145.144162000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812202159.52690.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 December 2008 02:31:47 Mike Travis wrote:
> Impact: Reduce stack usage, use new cpumask API.
> 
> Convert kernel/time functions to use struct cpumask *.
> 
> Note the ugly bitmap declarations in tick-broadcast.c.  These should
> be cpumask_var_t, but there was no obvious initialization function to
> put the alloc_cpumask_var() calls in.  This was safe.

I still would like see those bitmaps turned into real cpumask_var_t.  It
should be easy for someone who knows the code well, or has time to spend
making sure the initialization is early enough.

Cheers,
Rusty.
