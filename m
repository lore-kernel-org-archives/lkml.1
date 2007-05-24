Return-Path: <linux-kernel-owner+w=401wt.eu-S1751588AbXEXRtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbXEXRtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbXEXRsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:48:55 -0400
Received: from mga05.intel.com ([192.55.52.89]:19844 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750741AbXEXRsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:48:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,574,1170662400"; 
   d="scan'208";a="249341851"
Message-ID: <4655CFB8.7060708@linux.intel.com>
Date: Thu, 24 May 2007 10:47:36 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Roland Dreier <rdreier@cisco.com>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Status of CONFIG_FORCED_INLINING?
References: <200705231510.52932.rob@landley.net> <20070524171019.GA4470@stusta.de> <ada3b1m87pa.fsf@cisco.com> <200705241347.43727.rob@landley.net>
In-Reply-To: <200705241347.43727.rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> If the compiler can emit a warning "inline insanely large", we can use that to 
> fix it.  But a warning is not the same as silently doing something other than 
> what we told it to do.

It's not silent! that's what "inline" without the force is for!
Once you force it you shut the warning up!!!!
