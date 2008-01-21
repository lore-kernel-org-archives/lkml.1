Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbYAUSDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbYAUSDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 13:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbYAUSDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 13:03:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:49457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbYAUSDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 13:03:36 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH] x86_64: check if Tom2 is enabled
Date: Mon, 21 Jan 2008 19:03:27 +0100
User-Agent: KMail/1.9.6
Cc: Yinghai Lu <Yinghai.Lu@sun.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200801192045.17291.yinghai.lu@sun.com> <200801202257.47195.yinghai.lu@sun.com> <20080121172437.GA6722@cvg>
In-Reply-To: <20080121172437.GA6722@cvg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801211903.27215.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> is it possible to change 'l' and 'h' to 'low' and 'high'?
> 'cause 'l' does look like '1' (one) number...

It would be fine for me for someone to implement safe_rdtscll() and get rid
of l and h everywhere. IMHO all the l and h accesses of MSRs are just harder
to read and error prone over the ll 64bit variants.

But I didn't want to add it just for this.

-Andi
