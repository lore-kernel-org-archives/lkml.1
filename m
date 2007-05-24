Return-Path: <linux-kernel-owner+w=401wt.eu-S1750934AbXEXRO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750934AbXEXRO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750960AbXEXROq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:14:46 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:22696 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbXEXROo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:14:44 -0400
X-IronPort-AV: i="4.14,574,1170662400"; 
   d="scan'208"; a="2423418:sNHT19304568"
To: Adrian Bunk <bunk@stusta.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Rob Landley <rob@landley.net>,
       linux-kernel@vger.kernel.org
Subject: Re: Status of CONFIG_FORCED_INLINING?
X-Message-Flag: Warning: May contain useful information
References: <200705231510.52932.rob@landley.net>
	<46549937.1030306@linux.intel.com> <20070523212237.GH2098@stusta.de>
	<ada7iqz9qlj.fsf@cisco.com> <20070524171019.GA4470@stusta.de>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 24 May 2007 10:14:41 -0700
In-Reply-To: <20070524171019.GA4470@stusta.de> (Adrian Bunk's message of "Thu, 24 May 2007 19:10:19 +0200")
Message-ID: <ada3b1m87pa.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 May 2007 17:14:41.0585 (UTC) FILETIME=[04445A10:01C79E27]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > A function only belongs into a header file if we always want it inlined, 
 > otherwise it belongs into a C file.

Again, why?  Why don't we trust the compiler to decide if a function
should be inlined or not, even if the definition happens to be in a .h
file?

It seems like a perfectly valid optimization for the compiler to only
emit code once for a function and then call it where it is used, even
if that function happens to be defined in a .h file.

 - R.
