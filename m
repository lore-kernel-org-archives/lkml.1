Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbYGSKYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbYGSKYJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 06:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbYGSKXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 06:23:10 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:23975 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbYGSKXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 06:23:08 -0400
To: Arjan van de Ven <arjan@infradead.org>
Cc: Simon Arlott <simon@fire.lp0.eu>, linux-kernel@vger.kernel.org,
       dwalker@mvista.com
Subject: Re: [patch 0/3] fastboot patches series 1
From: Andi Kleen <andi@firstfloor.org>
References: <20080718151524.5ef9e29b@infradead.org>
	<488172E0.6050502@simon.arlott.org.uk>
	<20080718221630.2809abbd@infradead.org>
Date: Sat, 19 Jul 2008 12:22:43 +0200
In-Reply-To: <20080718221630.2809abbd@infradead.org> (Arjan van de Ven's message of "Fri, 18 Jul 2008 22:16:30 -0700")
Message-ID: <87tzem8970.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 Jul 2008 10:22:41.0051 (UTC) FILETIME=[6000B6B0:01C8E989]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:
>
> One possible theory is that we now run on both cpus and if they're out
> of sync timewise, things like delays suddenly are shorter than expected
> if time jumps around....

On systems with non synchronized TSC the clocksource watchdog tends
to disable the TSC time source only quite late in boot (on my systems
typically even after kernel boot). So yes this could be a problem.

However he has a AMD QC system where the TSCs are synchronized on the
hardware level and there's also no message from the watchdog disabling
TSC, so this isn't the problem causing this issue. Must be something else.

-Andi

