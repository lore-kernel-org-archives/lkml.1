Return-Path: <linux-kernel-owner+w=401wt.eu-S1765787AbXEVKfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765787AbXEVKfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 06:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757610AbXEVKfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 06:35:15 -0400
Received: from ns2.suse.de ([195.135.220.15]:60390 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757476AbXEVKfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 06:35:14 -0400
From: Andi Kleen <ak@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] i386: fix early usage of atomic_add_return and local_add_return on real i386
Date: Tue, 22 May 2007 12:34:27 +0200
User-Agent: KMail/1.9.1
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>
References: <1179827338.12708.110.camel@chaos>
In-Reply-To: <1179827338.12708.110.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705221234.28289.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 May 2007 11:48, Thomas Gleixner wrote:
> The check (boot_cpu_data.x86 == 3) in atomic_add_return() and
> local_add_return() fails, when those operations are used before
> boot_cpu_data is filled in.
>
> Change the check to (boot_cpu_data.x86 <= 3) to fix this.

That's a critical boot fix for 386, right?

-Andi
