Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbYJWCIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbYJWCIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbYJWCI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:08:27 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43346 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752107AbYJWCI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:08:27 -0400
Message-Id: <20081023020826.051012000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 19:08:26 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 00/35] cpumask: Replace cpumask_t with struct cpumask
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Resubmit: cleanup and rebase on latest tip/master.]

Redesign cpumask API to explicitly declare struct cpumask pointers to
the cpumask_* operators and add functions to make it easier to support
struct cpumask pointers on the stack.

This patchset supplies the infrastructure going forward to implement
this new struct cpumask API.  Many more patches (currently 58)  have
been written and tested to verify the functionality of this API.  These
will be submitted as soon as they are thoroughly tested.

Compiled and tested on x86_64.

Based on tip/master @ v2.6.27-6973-ga90cd11

-- 
