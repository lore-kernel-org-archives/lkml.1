Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbXEWV3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbXEWV3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 17:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbXEWV3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 17:29:04 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:25400 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963AbXEWV3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 17:29:01 -0400
X-IronPort-AV: i="4.14,571,1170662400"; 
   d="scan'208"; a="153525027:sNHT40465215"
To: Adrian Bunk <bunk@stusta.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Rob Landley <rob@landley.net>,
       linux-kernel@vger.kernel.org
Subject: Re: Status of CONFIG_FORCED_INLINING?
X-Message-Flag: Warning: May contain useful information
References: <200705231510.52932.rob@landley.net>
	<46549937.1030306@linux.intel.com> <20070523212237.GH2098@stusta.de>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 23 May 2007 14:28:56 -0700
In-Reply-To: <20070523212237.GH2098@stusta.de> (Adrian Bunk's message of "Wed, 23 May 2007 23:22:37 +0200")
Message-ID: <ada7iqz9qlj.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 May 2007 21:28:56.0303 (UTC) FILETIME=[5E5FD7F0:01C79D81]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > - every static function in a header file must be __always_inline

Why?  Why does it matter whether a function is defined in a .h file or
a .c file?  Can't the compiler decide better than we can whether
something should be inlined or not?

Your argument seems to imply that we should never use the inline
keyword at all.

 - R.
