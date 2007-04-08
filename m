Return-Path: <linux-kernel-owner+w=401wt.eu-S1751388AbXDHDdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbXDHDdT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 23:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbXDHDdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 23:33:19 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:53557 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbXDHDdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 23:33:18 -0400
Date: Sat, 7 Apr 2007 23:33:06 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: aeb@cwi.nl
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] partitions: Changes to fs/partitions for readability
 and efficiency
Message-ID: <alpine.DEB.0.83.0704072235180.27057@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In addition to the Kconfig help text patch I submitted earlier, this is a 
set of patches to touch up the partition handling files and also to change 
the "array of function pointers" algorithm of the main checking function 
to "list of calls to possible stub functions" to better fit in with the 
rest of the kernel code, to reduce memory usage by a few dozen bytes, and 
to generally be easier (in my opinion) to understand.
