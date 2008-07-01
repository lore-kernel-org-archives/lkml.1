Return-Path: <linux-kernel-owner+w=401wt.eu-S1759449AbYGAQOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449AbYGAQOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 12:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbYGAQOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 12:14:06 -0400
Received: from gw.goop.org ([64.81.55.164]:38092 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789AbYGAQOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 12:14:05 -0400
Message-ID: <486A57C8.3010008@goop.org>
Date: Tue, 01 Jul 2008 09:14:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <npiggin@suse.de>, Mark McLoughlin <markmc@redhat.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Stephen Tweedie <sct@redhat.com>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Xen-devel] Re: [PATCH 00 of 36] x86/paravirt: groundwork for
 64-bit Xen support
References: <20080626105818.GA13805@elte.hu> <4863A8E6.1010807@goop.org> <20080627160333.GA27072@elte.hu> <486539A3.3030102@goop.org> <20080629084318.GA28815@elte.hu> <48684CD4.7040403@goop.org> <20080630082135.GA22844@elte.hu> <20080630092209.GA29815@elte.hu> <48696690.90907@goop.org> <20080701085204.GA23289@elte.hu> <20080701092152.GA18918@elte.hu>
In-Reply-To: <20080701092152.GA18918@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Excluding the x86/xen-64bit topic solves the problem.
>
> It triggered on two 64-bit machines so it seems readily reproducible 
> with that config.
>
> i've pushed the failing tree out to tip/tmp.xen-64bit.Tue_Jul__1_10_55
>   

The patch to fix this is on tip/x86/unify-setup: "x86: setup_arch() && 
early_ioremap_init()".  Logically that patch should probably be in the 
xen64 branch, since it's only meaningful with the early_ioremap unification.

    J
