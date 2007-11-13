Return-Path: <linux-kernel-owner+w=401wt.eu-S1763073AbXKMTHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763073AbXKMTHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756341AbXKMTHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:07:19 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:45438 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756046AbXKMTHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:07:18 -0500
Message-Id: <20071113190302.988259011@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 13 Nov 2007 14:03:02 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [RFC 0/3] Linux Kernel Markers new features
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 13 Nov 2007 19:06:42 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Those are the new features I plan to add to the Markers :
- Support multiple probes per marker (so blktrace, LTTng, SystemTAP and others
  can coexist peacefully)
- Export the markers to a Module.markers file in modpost (for Systemtap)
- Use the Immediate values to optimize the branch when disabled.

I depends on the "Immediate Values" patchset and applies on top of
2.6.24-rc2-git3 in this order :

#RFC
markers-support-multiple-probes.patch
linux-kernel-markers-create-modpost-file.patch
linux-kernel-markers-immediate-values.patch

I submit those as a RFC for now.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
