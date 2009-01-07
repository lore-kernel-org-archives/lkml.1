Return-Path: <linux-kernel-owner+w=401wt.eu-S1760390AbZAGT6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760390AbZAGT6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755646AbZAGT6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:58:36 -0500
Received: from relay3.sgi.com ([192.48.171.31]:42341 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753446AbZAGT6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:58:35 -0500
Message-Id: <20090107195832.265117000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 07 Jan 2009 11:58:32 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] cpumask: more cpumask updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


One big change to irq_desc and a few smaller maintenance type updates.

	cpumask: update irq_desc to use cpumask_var_t
	cpumask: Use topology_core_cpumask()/topology_thread_cpumask()
	cpumask: convert misc driver functions
	cpumask: convert drivers/net/sfc
	cpumask: convert other misc kernel functions

Based on tip/cpus4096: v2.6.28-5703-g1d1a70e

(Ingo - I added a blank line before the From: part and that seems to
separate it from the Subject.  Hopefully your git-am will still
recognizes it - I did try a git-am here and it seemed to work ok.)

Signed-off-by: Mike Travis <travis@sgi.com>

-- 
