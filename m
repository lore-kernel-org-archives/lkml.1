Return-Path: <linux-kernel-owner+w=401wt.eu-S1760195AbYHVAgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195AbYHVAgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 20:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbYHVAgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 20:36:39 -0400
Received: from gw.goop.org ([64.81.55.164]:33537 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030AbYHVAgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 20:36:39 -0400
Message-ID: <48AE0A14.4090609@goop.org>
Date: Thu, 21 Aug 2008 17:36:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/2] smp_call_function: don't use lock in call_function_data
References: <48AE087C.4000408@goop.org>
In-Reply-To: <48AE087C.4000408@goop.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> There's no need for a lock in call_function_data, since it's only used
> to decrement-and-test a counter.  Use an atomic instead.

BTW, these two patches are against tip.git.

    J
