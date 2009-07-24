Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbZGXOHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbZGXOHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 10:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbZGXOHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 10:07:52 -0400
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:35273 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752745AbZGXOHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 10:07:52 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=ISO-8859-1
X-IronPort-AV: E=Sophos;i="4.43,264,1246831200";   d="scan'208";a="20262747"
Message-id: <4A69C03E.3090706@lih.rwth-aachen.de>
Date: Fri, 24 Jul 2009 16:07:58 +0200
From: =?ISO-8859-1?Q?Victor_Matar=E9?= <matare@lih.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090723)
To: linux-kernel@vger.kernel.org
Subject: clock freezes??
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a dual Xeon server (old Xeon HT) with an Intel E7505 chipset,
with hrtimer and dynticks enabled. On bootup, the kernel
(2.6.29-gentoo-r5) tells me it's using the PM-Timer bug workaround, but
then it uses tsc as clocksource. Now the clock was running slow for
about 15sec/12hrs, which is quite a lot. So in a careless moment, I just
tried "echo jiffies > clocksource0/current_clocksource". This froze the
system time. Now I couldn't switch back to tsc or acpi_pm, echoing those
was just ignored. Subsequently, the entire system locked up and I needed
to reboot.

Now what does that mean? Is this supposed to happen? Should I disable
dynticks and/or hrtimer?

thanks...

-- 
Victor Mataré
Server- & Netzwerk-Administration

Lehrstuhl für Ingenieurgeologie und Hydrogeologie der RWTH-Aachen
Lochnerstraße 4-20, 52064 Aachen

Tel: 0241 80 96778
Fax: 0241 80 92280

