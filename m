Return-Path: <linux-kernel-owner+w=401wt.eu-S1753410AbYISVTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbYISVTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 17:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbYISVT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 17:19:29 -0400
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:50492 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbYISVT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 17:19:29 -0400
Message-Id: <20080919203703.312007962@quilx.com>
User-Agent: quilt/0.46-1
Date: Fri, 19 Sep 2008 13:37:03 -0700
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
Subject: [patch 0/3] Cpu alloc slub support: Replace percpu allocator in slub.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slub also has its own per cpu allocator. Get rid of it and use cpu_alloc().

-- 
