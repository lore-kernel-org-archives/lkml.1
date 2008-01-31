Return-Path: <linux-kernel-owner+w=401wt.eu-S933118AbYAaMx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933118AbYAaMx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 07:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764205AbYAaMxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 07:53:21 -0500
Received: from ns.suse.de ([195.135.220.2]:56238 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756429AbYAaMxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 07:53:20 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/5] x86: change_page_attr_clear fix
Date: Thu, 31 Jan 2008 13:53:16 +0100
User-Agent: KMail/1.9.6
Cc: "Huang, Ying" <ying.huang@intel.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <1201764959.12950.22.camel@caritas-dev.intel.com> <200801310843.46831.ak@suse.de> <alpine.LFD.1.00.0801311333170.9204@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0801311333170.9204@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801311353.16633.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 January 2008 13:38:45 Thomas Gleixner wrote:
> On Thu, 31 Jan 2008, Andi Kleen wrote:
> 
> > On Thursday 31 January 2008 08:35:59 Huang, Ying wrote:
> > > This patch replaces __change_page_attr_set_clr() with
> > > change_page_attr_set_clr() in change_page_attr_clear() to flush the
> > > TLB/cache properly.
> > 
> > Good catch :-) It actually only needs to flush TLBs not caches in this 
> > case.
> 
> That's one of the items on our optimizations todo list already. There
> are more low hanging fruits, but we need to make sure that the non
> optimized version is bullet proof first.

I actually ported it already forward from my old patchkit (together
with some other improvements). Will post later.

-Andi
