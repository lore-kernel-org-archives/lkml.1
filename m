Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbYD2Wzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbYD2Wzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbYD2Wzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:55:31 -0400
Received: from www.tglx.de ([62.245.132.106]:46602 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbYD2Wza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:55:30 -0400
Date: Wed, 30 Apr 2008 00:54:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Gabriel C <nix.or.die@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mika Fischer <mika.fischer@zoopnet.de>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete
 layout v5
In-Reply-To: <m11w4oxq9i.fsf@frodo.ebiederm.org>
Message-ID: <alpine.LFD.1.10.0804300050070.6003@apollo.tec.linutronix.de>
References: <200804272337.40130.yhlu.kernel@gmail.com> <200804281244.56938.yhlu.kernel@gmail.com> <200804281316.14168.yhlu.kernel@gmail.com> <200804281505.05764.yhlu.kernel@gmail.com> <m1wsmg32qk.fsf@frodo.ebiederm.org> <86802c440804291304r7ff169f6k9132f98761ecef42@mail.gmail.com>
 <m1abjcz9ow.fsf@frodo.ebiederm.org> <86802c440804291457k79099d84w53110fabf59e9e37@mail.gmail.com> <m11w4oxq9i.fsf@frodo.ebiederm.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008, Eric W. Biederman wrote:
> Think of SMM mode is a lightweight hypervisor that we can't get rid
> of, if you want to understand the worst case.
> 
> In theory SMM mode is completely unnecessary as soon as we enable
> ACPI.  In practice ACPI appears to frequently trap into SMM mode.

SMM does more than that. It emulates legacy hardware and fixes
chip(set) bugs as well. Disabling it just makes your box stop
working. There are certain types of systems where essential safety
nets rely on SMIs (you can deep-fry P4s by disabling SMIs).

Thanks,
	tglx
