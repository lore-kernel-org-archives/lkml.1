Return-Path: <linux-kernel-owner+w=401wt.eu-S965641AbXAZNgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965641AbXAZNgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 08:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965651AbXAZNgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 08:36:41 -0500
Received: from twin.jikos.cz ([213.151.79.26]:44375 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965641AbXAZNgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 08:36:40 -0500
Date: Fri, 26 Jan 2007 14:35:31 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: mirek kratochvil <exa.exa@gmail.com>
cc: linux-kernel@vger.kernel.org, Francois Romieu <romieu@fr.zoreil.com>,
       netdev@vger.kernel.org
Subject: Re: r8169 problems on x86_64 (transmit timeout & crash)
In-Reply-To: <a37929f0701260500x68cf6bb0i8a5ef603794a861f@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0701261429200.1889@twin.jikos.cz>
References: <a37929f0701260500x68cf6bb0i8a5ef603794a861f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007, mirek kratochvil wrote:

> > In case you have BIOS 04.., try to upgrade to 06.. version. Also, does 
> > it help when you boot with acpi=off kernel commandline parameter? (do 
> > you compile kernel with both acpi and apic support?).
> Upgraded to bios 0802, but still the same problem. I think it's 
> definitely something about the r8169 driver. acpi=off doesn't help. 
> turning on/off apic also doesn't matter.

Added some relevant CCs; the thread started in lkml at 
http://lkml.org/lkml/2007/1/25/268

> one thing more - have confirmed that the bug is reproducible on *any* 
> laptop with 8168, not only Asus. I guess the disk-usage-crash was some 
> other bug.

Confusing ... the other day you stated that r1000 has the exactly same 
problem?

Thanks,

-- 
Jiri Kosina
SUSE Labs
