Return-Path: <linux-kernel-owner+w=401wt.eu-S1752299AbZGLAmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbZGLAmE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 20:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbZGLAlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 20:41:55 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:38255 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbZGLAlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 20:41:55 -0400
Date: Sun, 12 Jul 2009 01:41:54 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86,apic - set cpu_has_apic for discrete apic
In-Reply-To: <20090711212929.GG5325@lenovo>
Message-ID: <alpine.LFD.2.00.0907120141020.13862@eddie.linux-mips.org>
References: <20090711212929.GG5325@lenovo>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jul 2009, Cyrill Gorcunov wrote:

> In case of discrete apic (due to hardware or firmware reason)
> cpuid may not retrieve cpu_has_apic bit. So for SMP
> compiled kernels instead of long check we may set "fake"
> cpu_has_apic bit and check only the bit in further code
> flow.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
> 
> Please review carefully.

 Sure: how did you test it or plan to do so?

  Maciej
