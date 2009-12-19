Return-Path: <linux-kernel-owner+w=401wt.eu-S1751372AbZLSKLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372AbZLSKLg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 05:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbZLSKLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 05:11:35 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:53923 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbZLSKLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 05:11:34 -0500
From: Andreas Schwab <schwab@linux-m68k.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6 v5] CPU probe/release files
References: <4AE8ADCF.6090104@austin.ibm.com>
	<4AE8B072.1070603@austin.ibm.com> <m2oclw9wt4.fsf@igel.home>
	<1261212415.2173.94.camel@pasglop>
X-Yow: If I have enough money to buy 5,000 CANS of NOODLE-RONI, can I get a
 VAT of MARSHMALLOW FLUFF free??
Date: Sat, 19 Dec 2009 11:11:29 +0100
In-Reply-To: <1261212415.2173.94.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Sat, 19 Dec 2009 19:46:55 +1100")
Message-ID: <m26383jmsu.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

> Nathan, the problem is that the above wlil define ARCH_CPU_PROBE_RELEASE
> for any powerpc platform that has HOTPLUG_CPU. So a kernel that doesn't
> have pSeries support but has hotplug CPU will have a problem, though for
> some reason none of my test configs triggered it (I'll have to check why
> next week).

Perhaps you didn't enable CONFIG_SUSPEND.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
