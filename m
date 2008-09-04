Return-Path: <linux-kernel-owner+w=401wt.eu-S1756390AbYIDThq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390AbYIDThq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 15:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbYIDThj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 15:37:39 -0400
Received: from www.tglx.de ([62.245.132.106]:39366 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbYIDThi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 15:37:38 -0400
Date: Thu, 4 Sep 2008 21:37:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc2:stall while mounting root fs
In-Reply-To: <64bb37e0808120537qff93841xa657b46f6b36ddcd@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0809042135230.3243@apollo.tec.linutronix.de>
References: <64bb37e0808120537qff93841xa657b46f6b36ddcd@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Torsten,

On Tue, 12 Aug 2008, Torsten Kaiser wrote:

> [   59.722260]  [<ffffffff8020a256>] ? cpu_idle+0x66/0xc0

We just tracked down issues with C1E/HPET. Can you please try the patch
http://bugzilla.kernel.org/attachment.cgi?id=17622

which is a combo patch of queued fixed on top of 2.6.27-rc5 or on top
of Linus tree.

Thanks,

	tglx
