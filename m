Return-Path: <linux-kernel-owner+w=401wt.eu-S1756946AbYDMUh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbYDMUh2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 16:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbYDMUhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 16:37:20 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:38235 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbYDMUhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 16:37:19 -0400
From: Chr <chunkeey@web.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #10369] The never ending BEEEEP/__smp_call_function_mask with 2.6.25-rc7
Date: Sun, 13 Apr 2008 22:37:10 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik> <oq66hWjeF4N.A.ch.w3lAIB@albercik> <alpine.LFD.1.10.0804132156570.3261@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0804132156570.3261@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804132237.10401.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX1+3fMyrt9FxW/9iYGr+prt2hBW2Dw17LZKzfuXE
	YWg/3JtGIx50nX7U51A88CNutJUSwzbqaF1W3XjJbvvWr+y0Hl
	ju1aAG8Ys=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 April 2008 22:02:08 Thomas Gleixner wrote:
>
> The problem still persists and I have no clue at all what's the root
> cause. The symptom is a stuck local apic timer interrupt as we have
> seen it on those AMD X2 systems with C1E enabled. This box does not
> advertise C1E, but the behaviour is the same.
>
> Christian, it would be great if you could bisect the git tree so we
> get an idea which patch is exposing this problem. My feeling is that
> the problem itself is there with 2.6.24 as well but not
> exposed. That's just a gut feeling and I could be wrong as usual.

Ok! The biggest problem however is: I can only run bisects on weekends. :-(
And even then: it takes up to 2 hours until the timer gets stuck... and the 
system freezes...
But, on the other hand... does ANYBODY know a way how I can see if the 
apictimer drifts/(getting slower and slower)?

Regards,
	Chr.
