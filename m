Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbYDMUCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbYDMUCd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 16:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbYDMUCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 16:02:25 -0400
Received: from www.tglx.de ([62.245.132.106]:46755 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbYDMUCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 16:02:24 -0400
Date: Sun, 13 Apr 2008 22:02:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Chr <chunkeey@web.de>
Subject: Re: [Bug #10369] The never ending BEEEEP/__smp_call_function_mask
 with 2.6.25-rc7
In-Reply-To: <oq66hWjeF4N.A.ch.w3lAIB@albercik>
Message-ID: <alpine.LFD.1.10.0804132156570.3261@apollo.tec.linutronix.de>
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik> <oq66hWjeF4N.A.ch.w3lAIB@albercik>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.24.  Please verify if it still should be listed.

The problem still persists and I have no clue at all what's the root
cause. The symptom is a stuck local apic timer interrupt as we have
seen it on those AMD X2 systems with C1E enabled. This box does not
advertise C1E, but the behaviour is the same.

Christian, it would be great if you could bisect the git tree so we
get an idea which patch is exposing this problem. My feeling is that
the problem itself is there with 2.6.24 as well but not
exposed. That's just a gut feeling and I could be wrong as usual.

Thanks,

	tglx


