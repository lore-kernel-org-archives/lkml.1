Return-Path: <linux-kernel-owner+w=401wt.eu-S933795AbXCZXhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933795AbXCZXhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 19:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933805AbXCZXhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 19:37:12 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:4615 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933795AbXCZXhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 19:37:09 -0400
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: dead CONFIG variables in kernel Makefiles
X-Message-Flag: Warning: May contain useful information
References: <Pine.LNX.4.64.0703261924470.26815@CPE00045a9c397f-CM001225dbafb6>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 26 Mar 2007 16:37:04 -0700
In-Reply-To: <Pine.LNX.4.64.0703261924470.26815@CPE00045a9c397f-CM001225dbafb6> (Robert P. J. Day's message of "Mon, 26 Mar 2007 19:32:00 -0400 (EDT)")
Message-ID: <ada7it3k25b.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Mar 2007 23:37:04.0436 (UTC) FILETIME=[A8E65740:01C76FFF]
Authentication-Results: sj-dkim-8; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim8002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > ===== IPATH_CORE =====
 > ./drivers/Makefile:obj-$(CONFIG_IPATH_CORE)     += infiniband/

Thanks, I was just noticing that myself.  I'll remove it for 2.6.22.

 - R.
