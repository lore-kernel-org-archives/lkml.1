Return-Path: <linux-kernel-owner+w=401wt.eu-S1751713AbXAaWsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbXAaWsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 17:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbXAaWsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 17:48:41 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:3688 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbXAaWsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 17:48:41 -0500
Subject: Re: [PATCH 14/23] clocksource: increase initcall priority
From: Daniel Walker <dwalker@mvista.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070131194311.4B8381FD833@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <20070131194311.4B8381FD833@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 14:47:09 -0800
Message-Id: <1170283629.9781.163.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-31 at 11:43 -0800, David Brownell wrote:
> > As a note, arm and mips both register their clocksources during
> > time_init() instead of using initcalls.
> 
> That's actually platform-specific.  If there's only one possible
> clocksource, that'd be the normal answer.
> 
> Otherwise, there can be multiple clocksources just like any other
> architecture.  Maybe there's an always-present 32 KHz counter, and
> a bank of timers that can run at higher frequences ... but those
> may not be available for timekeeping on all boards, maybe because
> they're used for something else (motor control, etc) or because the
> system has prioritized battery life over timestamp precision.
> 
> So don't assume any platform doesn't use clocksource initcalls.

What does your OMAP clocksource do now ? I thought one of the changes
that you made was to have both 32k and mpu both registered ..

Daniel

