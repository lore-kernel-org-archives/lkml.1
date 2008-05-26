Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbYEZKM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbYEZKM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 06:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbYEZKMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 06:12:52 -0400
Received: from www.tglx.de ([62.245.132.106]:54598 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181AbYEZKMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 06:12:51 -0400
Date: Mon, 26 May 2008 12:12:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pierre Ossman <drzeus-list@drzeus.cx>
cc: LKML <linux-kernel@vger.kernel.org>, mingo@redhat.com, hpa@zytor.com
Subject: Re: gcc "internal error" with 32-bit userspace, 64-bit kernel
In-Reply-To: <20080525112728.6341c113@mjolnir.drzeus.cx>
Message-ID: <alpine.LFD.1.10.0805261211040.3295@apollo.tec.linutronix.de>
References: <20080525112728.6341c113@mjolnir.drzeus.cx>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 May 2008, Pierre Ossman wrote:
> I'm having a bit of a problem with the x86 32-bit compatibility and I
> don't really know how to debug it.
> 
> The problem is that gcc fails some builds with "internal error" when
> I'm running a 32-bit userspace on a 64-bit kernel. The same test
> scenario with a 32-bit kernel works fine.
> 
> More specifically, I'm using Red Hat's mock tool on Fedora 9 to build
> packages. It sets up a chroot:ed environment where (as far as I can
> tell) everything is from the target system. Building for 32-bit Fedora
> 8 succeeds, but not Fedora 9 or RHEL 5.
> 
> Ideas on how to proceed? From what I've read, the 32-bit compatibility
> of the kernel should be 100%.

Just tried to reproduce that with git of today. Did not happen.

Which kernel version are you using ?

Thanks,
	tglx


