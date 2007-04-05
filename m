Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbXDEQzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbXDEQzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 12:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbXDEQzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 12:55:51 -0400
Received: from terminus.zytor.com ([192.83.249.54]:56296 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbXDEQzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 12:55:50 -0400
Message-ID: <46152A04.1010009@zytor.com>
Date: Thu, 05 Apr 2007 09:55:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: limit mwait_idle to Intel CPUs
References: <20070405140045.GN6356@alberich.amd.com> <200704051624.45747.ak@suse.de> <20070405144442.GP6356@alberich.amd.com> <200704051737.17157.ak@suse.de> <20070405162049.GB14326@alberich.amd.com>
In-Reply-To: <20070405162049.GB14326@alberich.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Herrmann wrote:
> 
> It is not equivalent. Usually users check /proc/cpuinfo for their
> CPU features. Deleting that flag is kind of obfuscation.
> 
> I guess some time ago people did not care about their "svm" or "vmx"
> flags. Nowadays (e.g. with kvm) some people are quite happy
> if one of those strings occurs in /proc/cpuinfo (and they are quite
> disappointed if this feature was disabled by BIOS).
> 

What you're saying is that you want it to appear in /proc/cpuinfo for 
marketing reasons even though it's not usable.

The ones in /proc/cpuinfo are cooked values anyway; there is plenty of 
history to that effect.

I would agree with Andi that if as far as Linux is concerned mwait is 
unusable on AMD Fam10 processors, then the CPU detection code should 
turn this bit off on AMD Fam10 processors.

	-hpa

