Return-Path: <linux-kernel-owner+w=401wt.eu-S1760189AbZDIHML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760189AbZDIHML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 03:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755666AbZDIHLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 03:11:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42224 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537AbZDIHLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 03:11:55 -0400
Date: Thu, 9 Apr 2009 09:14:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, ying.huang@intel.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] [3/4] x86: MCE: Improve mce_get_rip
Message-ID: <20090409071413.GD14687@one.firstfloor.org>
References: <20090407506.675031434@firstfloor.org> <20090407150656.43E161D046D@basil.firstfloor.org> <49DC5D11.4060505@jp.fujitsu.com> <87eiw3a29h.fsf@basil.nowhere.org> <49DD80B4.5060301@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DD80B4.5060301@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 01:59:32PM +0900, Hidetoshi Seto wrote:
> >> I guess it would make much sense if we stop mixing RIP and EIP and rename
> >> the mce_get_rip() to mce_get_eip(), and the rip_msr to eip_msr too.
> > 
> > Ok fair enough.  I admit the code was always a bit dubious.
> > 
> >> And then it would be acceptable if we print RIP with "!INEXACT!" annotation
> >> instead of printing precise EIP in case of RIPV=0 but EIPV=1.
> > 
> > Please send a patch to do all that.
> 
> I will.
> 
> A trivial question is if you unified 32/64bit mce codes, would you
> like to print only "IP %02x:<%016Lx>", or "RIP ..." and "EIP ..." ?

I would prefer to pt in RIP in both cases, simply because i fear breaking
parsers. I think the 32bit users will survive if their instruction
pointer is reported as "RIP" too.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
