Return-Path: <linux-kernel-owner+w=401wt.eu-S1767172AbXDEVMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767172AbXDEVMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 17:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767309AbXDEVMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 17:12:12 -0400
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:36247 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767172AbXDEVMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 17:12:10 -0400
Date: Thu, 5 Apr 2007 23:12:08 +0200
From: aherrman@arcor.de
To: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, andreas.herrmann3@amd.com
Subject: RE: [PATCH] x86: limit mwait_idle to Intel CPUs
Message-ID: <20070405211208.GA8126@tweety.malo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46152A04.1010009@zytor.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Anvin wrote:
> Andreas Herrmann wrote:
> > 
> > It is not equivalent. Usually users check /proc/cpuinfo for their
> > CPU features. Deleting that flag is kind of obfuscation.
> > 
> > I guess some time ago people did not care about their "svm" or "vmx"
> > flags. Nowadays (e.g. with kvm) some people are quite happy
> > if one of those strings occurs in /proc/cpuinfo (and they are quite
> > disappointed if this feature was disabled by BIOS).
> > 

> What you're saying is that you want it to appear in /proc/cpuinfo for 
> marketing reasons even though it's not usable.

Bruellller!
So you are saying I am a marketing guy -- wasn't aware of that.
Just big fun.

> The ones in /proc/cpuinfo are cooked values anyway; there is plenty of 
> history to that effect.

I don't know this history. And I don't care.
I thought /proc/cpuinfo should show an (almost) complete list
of CPU features. If this is not the case it's a pity.

> I would agree with Andi that if as far as Linux is concerned mwait is 
> unusable on AMD Fam10 processors, then the CPU detection code should 
> turn this bit off on AMD Fam10 processors.

And finally I was not aware that you and Andi think of monitor/mwait
as a synonym for Intel's native C-States.

So I guess, what you really want is that for AMD CPUs the
monitor-flag (aka native C-state-flag) gets removed.

And if somedays another use case for monitor/mwait appears, the flag
has to be reintroduced for AMD CPUs.

Fine with me.
The only drawback is that Andi's idea of idle=mwait wouldn't make
sense anymore.


Regards,

Andreas

