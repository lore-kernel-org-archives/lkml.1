Return-Path: <linux-kernel-owner+w=401wt.eu-S933520AbYAaMjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933520AbYAaMjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 07:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764635AbYAaMjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 07:39:16 -0500
Received: from www.tglx.de ([62.245.132.106]:54421 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762468AbYAaMjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 07:39:15 -0500
Date: Thu, 31 Jan 2008 13:38:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: "Huang, Ying" <ying.huang@intel.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] x86: change_page_attr_clear fix
In-Reply-To: <200801310843.46831.ak@suse.de>
Message-ID: <alpine.LFD.1.00.0801311333170.9204@apollo.tec.linutronix.de>
References: <1201764959.12950.22.camel@caritas-dev.intel.com> <200801310843.46831.ak@suse.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008, Andi Kleen wrote:

> On Thursday 31 January 2008 08:35:59 Huang, Ying wrote:
> > This patch replaces __change_page_attr_set_clr() with
> > change_page_attr_set_clr() in change_page_attr_clear() to flush the
> > TLB/cache properly.
> 
> Good catch :-) It actually only needs to flush TLBs not caches in this 
> case.

That's one of the items on our optimizations todo list already. There
are more low hanging fruits, but we need to make sure that the non
optimized version is bullet proof first.

Thanks,

	tglx
