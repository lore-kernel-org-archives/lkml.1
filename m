Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbYDIMZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbYDIMZP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 08:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbYDIMZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 08:25:03 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:59264 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbYDIMZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 08:25:01 -0400
From: Chr <chunkeey@web.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10369] The never ending BEEEEP/__smp_call_function_mask with 2.6.25-rc7
Date: Wed, 9 Apr 2008 14:24:59 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <SvnMeM-aZi.A.x8E.s-_-HB@albercik>
In-Reply-To: <SvnMeM-aZi.A.x8E.s-_-HB@albercik>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804091424.59648.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX1/hiVIyuJuIeA4F8OA3Js32jFzu2zrErnsFvFz6
	yWLos9O7+yWI021/bkXZuFyYRfelGS/5u9itRb3V6xkDPhrBWX
	fypi62SSY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 April 2008 01:02:09 Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.24.  Please verify if it still should be listed.
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10369
> Subject		: The never ending BEEEEP/__smp_call_function_mask with 2.6.25-rc7
> Submitter	: Chr <chunkeey@web.de>
> Date		: 2008-03-30 21:09 (10 days old)
> References	: http://lkml.org/lkml/2008/3/30/87
> Handled-By	: Thomas Gleixner <tglx@linutronix.de>

It's still there in 2.6.25-rc8-git7. The workarounds so far:
either disable chronyd (NTP-Daemon: my system clock
is a bit too fast: ~ -0.879 seconds) or "noapictimer" parameter.

Regards,
	Chr.
