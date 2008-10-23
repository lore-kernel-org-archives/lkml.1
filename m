Return-Path: <linux-kernel-owner+w=401wt.eu-S1757731AbYJWQPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731AbYJWQPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 12:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbYJWQPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 12:15:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60249 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757445AbYJWQPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 12:15:35 -0400
Date: Thu, 23 Oct 2008 18:16:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, travis@sgi.com, Ingo Molnar <mingo@elte.hu>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH 6/7] work_on_cpu: use on
	x86/kernel/cpu/intel_cacheinfo.c
Message-ID: <20081023161612.GA21008@redhat.com>
References: <20081023005750.D0A11DDEF9@ozlabs.org> <20081023094621.GA7995@redhat.com> <200810240210.31573.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810240210.31573.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24, Rusty Russell wrote:
>
>  Can we use smp_call_function here instead?

I think you are right, smp_call_function_single() should be fine.

But please note I don't really understand this code ;)

Oleg.

