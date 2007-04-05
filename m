Return-Path: <linux-kernel-owner+w=401wt.eu-S1753014AbXDEBab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbXDEBab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 21:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbXDEBab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 21:30:31 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:40415 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010AbXDEBaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 21:30:30 -0400
Date: Wed, 4 Apr 2007 18:29:56 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       William Lee Irwin III <wli@holomorphy.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 07/20] Allow paravirt backend to choose kernel PMD sharing
Message-ID: <20070405012956.GM19575@sequoia.sous-sol.org>
References: <20070404191151.009821039@goop.org> <20070404191205.392155702@goop.org> <Pine.LNX.4.64.0704041729300.22161@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704041729300.22161@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> Acked-by: Christoph Lameter <clameter@sgi.com>
> 
> for all thats worth since I am not a i386 specialist.
> 
> How much of the issues with page struct sharing between slab and arch code 
> does this address?

I think the answer is 'none yet.'  It uses page sized slab and still
needs pgd_list, for example.  But the mm_list chaining should work too,
so it shouldn't make things any worse.

thanks,
-chris
