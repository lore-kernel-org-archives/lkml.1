Return-Path: <linux-kernel-owner+w=401wt.eu-S1760618AbYAUQaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760618AbYAUQaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 11:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755076AbYAUQap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 11:30:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:41180 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916AbYAUQao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 11:30:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,227,1199692800"; 
   d="scan'208";a="327825638"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Yinghai Lu <Yinghai.Lu@sun.com>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v2
Date: Mon, 21 Jan 2008 08:30:21 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>
References: <200801192045.17291.yinghai.lu@sun.com> <200801202255.58642.yinghai.lu@sun.com> <200801202256.48365.yinghai.lu@sun.com>
In-Reply-To: <200801202256.48365.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801210830.22322.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 20, 2008 10:56 pm Yinghai Lu wrote:
> [PATCH] x86_32: trim memory by updating e820 v2
>
> when mtrr is not covering all e820 table, need to trim the ram, need to
> update e820
>
> reuse some code for x86_64
>
> here need to add early_identify_cpu for x86_32, and move mtrr_bp_init early
>
> compiled test only, need someone test it

I like this approach too.  So as long as the E820 modification method works 
(i.e. we have some testers, maybe Justin can give it a try), you can add

Signed-off-by:  Jesse Barnes <jesse.barnes@intel.com>

or

Acked-by:  Jesse Barnes <jesse.barnes@intel.com>

as appropriate too.

Thanks,
Jesse
