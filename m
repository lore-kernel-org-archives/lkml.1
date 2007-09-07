Return-Path: <linux-kernel-owner+w=401wt.eu-S1757089AbXIGEJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbXIGEJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 00:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbXIGEJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 00:09:47 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55514 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750751AbXIGEJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 00:09:47 -0400
Message-Id: <20070907040943.467530005@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 06 Sep 2007 21:09:43 -0700
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] core: fix build error when referencing arch specific structures
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Since the core kernel routines need to reference cpu_sibling_map,
whether it be a static array or a per_cpu data variable, an access
function has been defined.

In addition, changes have been made to the ia64 and ppc64 arch's to
move the cpu_sibling_map from a static cpumask_t array [NR_CPUS] to
be per_cpu cpumask_t arrays.

Note that I do not have the ability to build or test patch 3/3, the
ppc64 changes.

Patches are referenced against 2.6.23-rc4-mm1 .

-- 
