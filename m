Return-Path: <linux-kernel-owner+w=401wt.eu-S1752658AbXDQMJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbXDQMJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 08:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbXDQMJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 08:09:10 -0400
Received: from smtp19.orange.fr ([80.12.242.17]:63316 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbXDQMJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 08:09:09 -0400
X-ME-UUID: 20070417120149727.B186760000B4@mwinf1913.orange.fr
Date: Tue, 17 Apr 2007 14:01:48 +0200
From: Jean-Daniel Pauget <jd@disjunkt.com>
To: CaT <cat@zip.com.au>
Cc: Michael Chan <mchan@broadcom.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: intermittant petabyte usage reported with broadcom nic
Message-ID: <20070417120148.GB5510@disjunkt.com>
References: <20070402014319.GA8345@zip.com.au> <20070402001300.3b66007d.akpm@linux-foundation.org> <20070402074108.GB8345@zip.com.au> <1176596401.5847.7.camel@dell> <1176750651.6217.3.camel@dell> <20070416234348.GF8345@zip.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070416234348.GF8345@zip.com.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 09:43:48AM +1000, CaT wrote:
> On Mon, Apr 16, 2007 at 12:10:51PM -0700, Michael Chan wrote:
> > On Sat, 2007-04-14 at 17:20 -0700, Michael Chan wrote:
> > 
> > Here's the debug patch for x86 only that will change the statistics
> > memory block to read-only.  If the kernel is corrupting it, you should
> > get a page fault that will crash the system.  If you continue to see
> > bogus counters, it is definitely a firmware or hardware problem.  Please
> > try it and let me know.  Thanks.
[.../...]
> Perhaps Jean-Daniel, who is also experiencing this problem and seemingly
> more frequently then I, has a box that he could run your patch on. I
> think we both run pretty-much the same hardware (Dell [12]950s).
    Dell 1950/2950 indeed...

    if there is any way to catch that writing without crashing the system 
    (even to the price of some slowness) I can test it. if not, I can't 
    because all my available targets are remote administrated and involved 
    with production processes.
    if luckilly one of them gets free, I'll to apply the latest patch you'd 
    provide me. I may also try it one day I'm close to those machines, so 
    keep me in the list of up to date patches.

-- 
    Jean-Daniel Pauget

    Tél: +33 (0)2 33 17 20 16
    2, rue André PELCA
    50580 Denneville-Plage
    France

