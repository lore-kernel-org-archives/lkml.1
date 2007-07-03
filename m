Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbXGCQpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbXGCQpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756382AbXGCQpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:45:22 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:45761 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbXGCQpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:45:17 -0400
Message-Id: <20070703164046.645090494@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jul 2007 12:40:46 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 00/10] Immediate Values
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue,  3 Jul 2007 16:45:13 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the update to the Immediate Values patch. It provides a value with a
load immediate instruction instead of requiring a data load which could hurt the
data cache. It aims at providing a very efficient manner to branch over
compiled-in but mostly inactive code.

This release takes care of the modifications suggested in the previous round of
review (thanks to all reviewers!).

It applies on 2.6.22-rc6-mm1, and depends on the text edit lock patch.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
