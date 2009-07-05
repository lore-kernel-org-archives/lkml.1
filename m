Return-Path: <linux-kernel-owner+w=401wt.eu-S1755645AbZGETTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbZGETTl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 15:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbZGETTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 15:19:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60484 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbZGETTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 15:19:33 -0400
Message-ID: <4A50FC68.1030002@zytor.com>
Date: Sun, 05 Jul 2009 12:18:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: "Maciej W. Rozycki" <macro@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86,apic -- reduce disable_apic usage
References: <20090705162044.GC4791@lenovo> <alpine.LFD.2.00.0907051737100.13862@eddie.linux-mips.org> <4A50E323.6060109@zytor.com> <20090705190211.GK4791@lenovo>
In-Reply-To: <20090705190211.GK4791@lenovo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> 
> Peter, Maciej but how kernel behaved on older cpu long time ago?
> 
> I mean -- should user pass "lapic" cmdline option too be
> able to use apic functionality? (i'm asking since I just
> don't know how it had been working before). Current
> code (if only I'm not _missing_ something) relies on cpu_has_apic
> bit. And even if MP table has been parsed and APIC base found,
> cpu_has_apic could be not set so detect_init_APIC will fail
> if no "lapic" option passed (in case of old cpu without this cpuid
> bit produced) as we eventually stay with pic mode.
> 

Well, systems with discrete APICs were few and far between.  I'm not
sure if there are any such systems still in meaningful existence (kind
of like Voyager.)  That makes it a bit hard to test things, and
certainly means we shouldn't bend over backwards in doing *anything*
that could possibly break other machines.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

