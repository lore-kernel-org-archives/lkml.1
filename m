Return-Path: <linux-kernel-owner+w=401wt.eu-S1752700AbYHRGlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbYHRGlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 02:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbYHRGlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 02:41:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43569 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbYHRGk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 02:40:59 -0400
Date: Mon, 18 Aug 2008 08:42:40 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       David Fries <david@fries.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix i486 suspend to disk CR4 oops
Message-ID: <20080818064240.GC9807@one.firstfloor.org>
References: <20080818040340.GB17528@spacedout.fries.net> <Pine.LNX.4.55.0808180510480.26857@cliff.in.clinika.pl> <48A8FC21.9060908@zytor.com> <87skt2270c.fsf@basil.nowhere.org> <48A9180A.8020803@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A9180A.8020803@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2008 at 11:34:50PM -0700, H. Peter Anvin wrote:
> Andi Kleen wrote:
> >>>
> >>The other alternative is to probe for the CPUID instruction (via
> >>EFLAGS.ID) -- CR4 is present if and only if CPUID exists.
> >
> >Can be already checked for with boot_cpu_data.extended_cpuid_level.
> >
> 
> I believe you mean just plain cpuid_level (which is set to -1 if CPUID 
> doesn't exist.)  extended_cpuid_level is only defined on x86-64, but all 
> x86-64 CPUs have CR4.

Yes I meant plain cpuid_level. Just wanted to mention that before someone
opencodes another cpuid test.

-Andi
