Return-Path: <linux-kernel-owner+w=401wt.eu-S1755679AbYB0RCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbYB0RCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 12:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbYB0RCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 12:02:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbYB0RCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 12:02:06 -0500
Date: Wed, 27 Feb 2008 12:01:40 -0500
From: Jason Baron <jbaron@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [patch 1/7] Immediate Values - Architecture Independent Code
Message-ID: <20080227170132.GA7678@redhat.com>
References: <20080202210828.840735763@polymtl.ca> <20080202211204.268876860@polymtl.ca> <20080226225242.GA15926@redhat.com> <20080226231248.GA32455@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226231248.GA32455@Krystal>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 06:12:48PM -0500, Mathieu Desnoyers wrote:
> Hrm, does your stop machine implementation disable interrupts while the
> CPUs busy loop ?
> 

yes. this is how stop_machine is implemented...and I believe is consistent with
the way in which your algorithm disables irqs. The logic to me, is we don't
want any cpus to see the kernel text in an inconsistent state via an irq.

-Jason

