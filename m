Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbYJWPBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbYJWPBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 11:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYJWPBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 11:01:14 -0400
Received: from ozlabs.org ([203.10.76.45]:32977 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756226AbYJWPBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 11:01:13 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [bug #2] Re: [PATCH 00/35] cpumask: Replace cpumask_t with struct cpumask
Date: Fri, 24 Oct 2008 02:01:14 +1100
User-Agent: KMail/1.9.10
Cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <20081023125529.GA18327@elte.hu> <20081023142025.GA18804@elte.hu>
In-Reply-To: <20081023142025.GA18804@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810240201.15037.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 October 2008 01:20:25 Ingo Molnar wrote:
> Thomas has started a -tip cross-build test, and there's massive
> cross-build failures as well due to the cpumask changes:

Yes.  linux-next reported the same thing.  I've backed out various arch 
changes for this reason.

> it seems to me that this commit is massively borked:
>
>   4a792c2: cpumask: make CONFIG_NR_CPUS always valid

Yep.  This is the big one I dropped.  There are a few others; Mike is just 
porting the changes across to your tree now.

Cheers,
Rusty.
