Return-Path: <linux-kernel-owner+w=401wt.eu-S933170AbXLNEc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170AbXLNEc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 23:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760703AbXLNEct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 23:32:49 -0500
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:15105 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754AbXLNEcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 23:32:47 -0500
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: venkatesh.pallipadi@intel.com, ak@muc.de, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, akpm@linux-foundation.org,
       arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 06/12] PAT 64b: Add ioremap_wc support
X-Message-Flag: Warning: May contain useful information
References: <20071213235543.568682000@intel.com>
	<20071213235712.339088000@intel.com> <ada8x3x7vw5.fsf@cisco.com>
	<m1sl25q4rc.fsf@ebiederm.dsl.xmission.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 13 Dec 2007 20:32:45 -0800
In-Reply-To: <m1sl25q4rc.fsf@ebiederm.dsl.xmission.com> (Eric W. Biederman's message of "Thu, 13 Dec 2007 21:28:23 -0700")
Message-ID: <ada4pel7v6a.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Dec 2007 04:32:45.0585 (UTC) FILETIME=[5FAD5810:01C83E0A]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > Also I didn't see anything like pgprot_wc() in the patchset (although

 > pgprot_writcombined.

Oh I see it now (pgprot_writecombine() actually).

However the same comment as before applies: there needs to be a
fallback to pgprot_noncached() for all other architectures so that
drivers can actually use it in a sane way.

 - R.
