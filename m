Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbXDLXSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbXDLXSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 19:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbXDLXSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 19:18:46 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:34711 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbXDLXSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 19:18:45 -0400
X-IronPort-AV: i="4.14,405,1170662400"; 
   d="scan'208"; a="477908811:sNHT240305690"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: CaT <cat@zip.com.au>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Michael Chan <mchan@broadcom.com>
Subject: Re: intermittant petabyte usage reported with broadcom nic
X-Message-Flag: Warning: May contain useful information
References: <20070402014319.GA8345@zip.com.au>
	<20070402001300.3b66007d.akpm@linux-foundation.org>
	<20070412225249.GU8345@zip.com.au>
	<20070412161305.09cb28b8.akpm@linux-foundation.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 12 Apr 2007 16:18:24 -0700
In-Reply-To: <20070412161305.09cb28b8.akpm@linux-foundation.org> (Andrew Morton's message of "Thu, 12 Apr 2007 16:13:05 -0700")
Message-ID: <adaodltdvwf.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Apr 2007 23:18:24.0590 (UTC) FILETIME=[DE7126E0:01C77D58]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > Apr 11 22:14:02 '  eth0:220898233988841368 66750274    0    0    0     0          0  86458738 52386430545 101089219 199313    0    0     0  199313          0 '

 > > Apr 11 22:15:02 '  eth0:17227454818 81381144    0    0    0     0          0         0 33091307388 86658381    0    0    0     0       0          0 '

 > But in fact I think you're saying that the numbers go bad, and then stay bad.

Doesn't look like it -- one minute after the first hiccup the eth0 #s
look reasonable again.

 - R.
