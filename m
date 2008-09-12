Return-Path: <linux-kernel-owner+w=401wt.eu-S1758088AbYILWZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088AbYILWZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 18:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756920AbYILWZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 18:25:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43506 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567AbYILWZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 18:25:31 -0400
Date: Sat, 13 Sep 2008 00:29:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] apci: dump slit
Message-ID: <20080912222928.GB11730@one.firstfloor.org>
References: <1221243468-8016-1-git-send-email-yhlu.kernel@gmail.com> <20080912122031.eca8723e.akpm@linux-foundation.org> <86802c440809121229i14727af4nd1416044b06ebb94@mail.gmail.com> <878wtxrrwh.fsf@basil.nowhere.org> <alpine.LFD.1.10.0809122313440.13819@apollo.tec.linutronix.de> <20080912213053.GR7714@one.firstfloor.org> <86802c440809121454v5302d79ds8c6e1e6ca948059a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809121454v5302d79ds8c6e1e6ca948059a@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 02:54:12PM -0700, Yinghai Lu wrote:
> On Fri, Sep 12, 2008 at 2:30 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >
> > Yes excellent point.  Should we dump the complete ACPI tables?
> > Do you prefer hexdump
> 
> good point. there is one time BIOS put blank slit there. (only have
> acpi table header)
> only after dump that earlier in kernel boot log, they shut up and go
> back to fix their problem.

You should have asked them to run firmwaretestkit (and if fwtestkit 
doesn't test for a correct SLIT fix it there). That is what
it is for. But adding it 
to all Linux bootlogs ever just for this special case is the wrong way.


-Andi

-- 
ak@linux.intel.com
