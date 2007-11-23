Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbXKWLXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbXKWLXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 06:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbXKWLXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 06:23:01 -0500
Received: from mail164.messagelabs.com ([216.82.253.131]:52212 "HELO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755040AbXKWLXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 06:23:00 -0500
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-9.tower-164.messagelabs.com!1195816978!16412156!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
Date: Fri, 23 Nov 2007 12:24:42 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: NOHZ: local_softirq_pending 20
Message-ID: <20071123112442.GA12047@bre-cln-ukleine.digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 23 Nov 2007 11:22:57.0827 (UTC) FILETIME=[330AAF30:01C82DC3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

my kernel reported:

	NOHZ: local_softirq_pending 20

I cannot interpret it, but probably this is bad, because before
bc5393a6c9c0e70b4b43fb2fb63e3315e9a15c8f this used to BUG().

This happend while having a high load.  Up to now it only happend once
and I cannot reproduce it.

The machine is a cc7ucamry running v2.6.24-rc3-36-g4dd2d66[1].
Config and dmesg is available at

	http://www.modarm9.com/~ukleinek/20071123-local_softirq_pending/

Maybe the relevant source file is arch/arm/mach-ns9xxx/time-ns921x.c?


[1] available at
git://www.modarm9.com/gitsrc/pub/people/ukleinek/linux-2.6.git
	


-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
