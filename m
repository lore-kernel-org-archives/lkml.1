Return-Path: <linux-kernel-owner+w=401wt.eu-S1759341AbXGSKnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341AbXGSKnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756778AbXGSKmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 06:42:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36356 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208AbXGSKmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 06:42:45 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: =?utf-8?q?Bj=C3=B6rn_Steinbrink?= <B.Steinbrink@gmx.de>
Subject: Re: [PATCH] [20/58] x86: Always probe the NMI watchdog
Date: Thu, 19 Jul 2007 12:42:32 +0200
User-Agent: KMail/1.9.6
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
References: <200707191154.642492000@suse.de> <20070719095505.4430614E06@wotan.suse.de> <20070719102405.GB6581@atjola.homenet>
In-Reply-To: <20070719102405.GB6581@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200707191242.32375.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 12:24:05 BjÃ¶rn Steinbrink wrote:
> On 2007.07.19 11:55:05 +0200, Andi Kleen wrote:
> > 
> > From: [** iso-8859-1 charset **] BjörnSteinbrink <B.Steinbrink@gmx.de>
> > 
> > The performance counter allocator relies on the nmi watchdog being
> > probed, so we have to do that even if the watchdog is not enabled.
> 
> Are you going to revert your fixes to the msr->bit conversions? Or is
> this patch still required with them in place? I actually like your fix,
> as it also fixes the semantics of single_msr_reserve() (see other mail).
> 
> So, can we just drop this one?

Sorry, i already dropped it during final review; but it was still
in the list of patches to send out for review.

-Andi
