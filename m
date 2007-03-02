Return-Path: <linux-kernel-owner+w=401wt.eu-S965655AbXCBVVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965655AbXCBVVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 16:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965656AbXCBVVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 16:21:00 -0500
Received: from ruby.spiritone.com ([216.99.193.130]:55232 "EHLO
	ruby.spiritone.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965655AbXCBVU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 16:20:59 -0500
Message-ID: <45E894FA.2040103@BitWagon.com>
Date: Fri, 02 Mar 2007 13:19:54 -0800
From: John Reiser <jreiser@BitWagon.com>
Organization: -
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Paul Mundt <lethal@linux-sh.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + fully-honor-vdso_enabled.patch added to -mm tree
References: <20070301175207.GA849@tv-sign.ru> <20070302034800.GA12530@linux-sh.org> <20070302193219.GA87@tv-sign.ru>
In-Reply-To: <20070302193219.GA87@tv-sign.ru>
X-Enigmail-Version: 0.92.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:

> Still, I don't understand why we don't pass NEW_AUX_ENT(AT_SYSINFO) when
> vdso_enabled == 0. We don't need linux-gate.so to use __kernel_vsyscall,
> we have FIX_VDSO. In that case we should s/PAGE_KERNEL_RO/PAGE_READONLY/
> of course. I guess the reason is some magic in glibc.

In the past there were problems where user code could not single-step
(or even read the code of) such system calls.  Can these two operations
be performed today with what you propose, particularly if FIX_VDSO is
near 0xfffff000 ?

-- 
John Reiser, jreiser@BitWagon.com
