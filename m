Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbZADDnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbZADDnZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 22:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbZADDnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 22:43:17 -0500
Received: from ozlabs.org ([203.10.76.45]:34748 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbZADDnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 22:43:17 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] ia64: cpumask fix for is_affinity_mask_valid()
Date: Sun, 4 Jan 2009 14:13:11 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Travis <travis@sgi.com>, linux-kernel@vger.kernel.org
References: <200901011149.18401.rusty@rustcorp.com.au> <20090103105208.GA19080@elte.hu> <20090103115904.GA440@elte.hu>
In-Reply-To: <20090103115904.GA440@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901041413.12187.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 January 2009 22:29:04 Ingo Molnar wrote:
> update it to cpumask_var_t.

Please change it to a const struct cpumask_t *.

It should be const, and of course 'const cpumask_var_t' isn't the same.

Thanks,
Rusty.
