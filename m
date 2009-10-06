Return-Path: <linux-kernel-owner+w=401wt.eu-S932846AbZJFOlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846AbZJFOlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932722AbZJFOls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:41:48 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:38597 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932703AbZJFOls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:41:48 -0400
Message-Id: <20091006143727.868480435@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 06 Oct 2009 10:37:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [patch 0/4] DEBUG_RCU_HEAD: Debug and fix racy call_rcu() users
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Tue,  6 Oct 2009 14:40:34 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a patchset, done on 2.6.30.9, which permits to detect and fix racy
call_rcu() users.

Fix for vunmap, which happens to be one of them, is included.

Note that some false-positives might come up when call_rcu() is called on
uninitialized struct rcu_head. The solution is, surprisingly enough, to
initialize them.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
