Return-Path: <linux-kernel-owner+w=401wt.eu-S933898AbXHGRId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933898AbXHGRId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 13:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756183AbXHGRIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 13:08:24 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:1390 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbXHGRIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 13:08:23 -0400
Subject: Re: Hang on 8-way with 2.6.23-rc2-rt2
From: Daniel Walker <dwalker@mvista.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1186427253.21381.135.camel@ghaskins-t60p.haskins.net>
References: <1186427253.21381.135.camel@ghaskins-t60p.haskins.net>
Content-Type: text/plain
Date: Tue, 07 Aug 2007 10:03:37 -0700
Message-Id: <1186506217.22044.38.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 15:07 -0400, Gregory Haskins wrote:
> Hi Ingo,
>   I think there is a latent race condition somewhere in the code.  We
> find that -rt works on our 4-way (and under) systems, but have problems
> on our 8-ways.
> 
> If you run without nmi_watchdog, the system will sometimes boot (but
> very very very slow), and sometimes it will softlockup.  If you turn on
> nmi_watchdog, the system detects a hang (probably at the point where the
> system gets really slow without it).  We notice no problems on the
> 4-ways.
> 
> The system where we can reproduce this is a Dell 690 with Dual 2Ghz
> Quad-core Xeon 5335s.  I've attached some relevant info.  Let me know if
> you need more.

Could you drop the following config options and test again?

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

(btw, added LKML to the CC list ..)

Daniel

