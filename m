Return-Path: <linux-kernel-owner+w=401wt.eu-S933326AbXGSKpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326AbXGSKpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbXGSKpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 06:45:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36490 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbXGSKpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 06:45:30 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: =?utf-8?q?Bj=C3=B6rn_Steinbrink?= <B.Steinbrink@gmx.de>
Subject: Re: [PATCH] [21/58] i386: Reserve the right performance counter for the Intel PerfMon NMI watchdog
Date: Thu, 19 Jul 2007 12:45:26 +0200
User-Agent: KMail/1.9.6
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
References: <200707191154.642492000@suse.de> <20070719095506.52E3214E06@wotan.suse.de> <20070719102145.GA6581@atjola.homenet>
In-Reply-To: <20070719102145.GA6581@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200707191245.26604.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 12:21:45 BjÃ¶rn Steinbrink wrote:
> On 2007.07.19 11:55:06 +0200, Andi Kleen wrote:
> > 
> > From: [** iso-8859-1 charset **] BjörnSteinbrink <B.Steinbrink@gmx.de>
> > 
> > The Intel PerfMon NMI watchdog was using the generic reservation
> > function which always reserves the first performance counter. But the
> > watchdog actually uses the second performance counter, thus we need a
> > specialised function.
> 
> Ah, almost forgot about that patch. Actually, thanks to your fix that
> basically reverted the msr->offset conversation to its 2.6.21
> implementation, single_msr_reserve has sane semantics now and does just
> what the name suggests (before, the wd_ops entries had to store the
> "base" msrs, so it was really a first_msr_reserve).
> 
> With wd_ops->perfctr no longer needed to be the base msr, we can just
> fix that value for the arch perfmon watchdog. (And maybe we should
> remove the values for those implementations that don't employ the
> single_msr_reserve() stuff?)

I replaced the patch with the new patch, thanks

-Andi

