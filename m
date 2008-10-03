Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbYJCP3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbYJCP3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbYJCP0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:26:25 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:35593 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbYJCP0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:26:23 -0400
Message-Id: <20081003152436.089811999@quilx.com>
User-Agent: quilt/0.46-1
Date: Fri, 03 Oct 2008 08:24:36 -0700
From: Christoph Lameter <cl@linux-foundation.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
CC: linux-mm@kvack.org
Cc: jeremy@goop.org
Cc: ebiederm@xmission.com
Cc: travis@sgi.com
Cc: herbert@gondor.apana.org.au
Cc: xemul@openvz.org
Cc: penberg@cs.helsinki.fi
Subject: [patch 0/3] Cpu alloc slub support V2: Replace percpu allocator in slub.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slub also has its own per cpu allocator. Get rid of it and use cpu_alloc().

V1->V2
- Fix 2 bugs in patches (node[] array problem, inverted check)
- Change reservation of percpu area defaults.

-- 
