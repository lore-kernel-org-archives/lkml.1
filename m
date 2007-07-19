Return-Path: <linux-kernel-owner+w=401wt.eu-S937880AbXGSKf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937880AbXGSKf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932486AbXGSKYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 06:24:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:56840 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S964900AbXGSKYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 06:24:04 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1+4/nxkVCO4MhbbeQGV+DYZ+oFl6FBEHFgaBKs9gH
	vpTJhPnvF4j0LB
Date: Thu, 19 Jul 2007 12:24:05 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [20/58] x86: Always probe the NMI watchdog
Message-ID: <20070719102405.GB6581@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Andi Kleen <ak@suse.de>, patches@x86-64.org,
	linux-kernel@vger.kernel.org
References: <200707191154.642492000@suse.de> <20070719095505.4430614E06@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070719095505.4430614E06@wotan.suse.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.07.19 11:55:05 +0200, Andi Kleen wrote:
> 
> From: [** iso-8859-1 charset **] BjörnSteinbrink <B.Steinbrink@gmx.de>
> 
> The performance counter allocator relies on the nmi watchdog being
> probed, so we have to do that even if the watchdog is not enabled.

Are you going to revert your fixes to the msr->bit conversions? Or is
this patch still required with them in place? I actually like your fix,
as it also fixes the semantics of single_msr_reserve() (see other mail).

So, can we just drop this one?

Thanks,
Björn
