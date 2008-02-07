Return-Path: <linux-kernel-owner+w=401wt.eu-S935176AbYBGVTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935176AbYBGVTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934104AbYBGVD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:03:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934857AbYBGVDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:03:55 -0500
Date: Thu, 7 Feb 2008 16:03:26 -0500
From: Jason Baron <jbaron@redhat.com>
To: mathieu.desnoyers@polymtl.ca
Cc: akpm@linux-foundation.org, mingo@elte.hu, fche@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [patch 0/4] make pr_debug() dynamic
Message-ID: <20080207210320.GA14732@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi,

make the pr_debug() function dependent upon the new immediate infrastruture.
Thus, b/c of the low runtime impact, we can dynamically enable/disable
pr_debug withoug recompiling. Patch allows 'pr_debug=0/1' on the command
line or via /proc/sys/debug/pr_debug.

thanks,

-Jason

