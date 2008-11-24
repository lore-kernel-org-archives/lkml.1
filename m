Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbYKXX2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbYKXX2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 18:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbYKXX2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 18:28:07 -0500
Received: from ozlabs.org ([203.10.76.45]:50264 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754702AbYKXX2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 18:28:05 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PULL] cpumask conversion patches for sched
Date: Tue, 25 Nov 2008 09:57:07 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: Mike Travis <travis@sgi.com>, linux-kernel@vger.kernel.org
References: <200811250238.53883.rusty@rustcorp.com.au> <20081124171749.GB27851@elte.hu> <20081124172343.GB11971@elte.hu>
In-Reply-To: <20081124172343.GB11971@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811250957.07332.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 November 2008 03:53:43 Ingo Molnar wrote:
> plus there's a build failure as well on 32-bit:
>
> kernel/sched_rt.c:1561: error: 'per_cpu__local_cpu_mask' undeclared

Ah, CONFIG_SMP=n.  Problems in several patches; I split fix for easier
rebasing if you want to later.

Thanks,
Rusty.
