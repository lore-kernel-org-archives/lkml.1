Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbZG1TZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbZG1TZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 15:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbZG1TZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 15:25:28 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:21004 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbZG1TZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 15:25:27 -0400
Date: Tue, 28 Jul 2009 15:25:12 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andreas Mohr <andi@lisas.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: Dynamic configure max_cstate
In-reply-to: <4e5e476b0907280020x242d9ef7gfa05c3d7b66f941f@mail.gmail.com>
Message-id: <alpine.LFD.2.00.0907281522290.16740@localhost.localdomain>
References: <20090727073338.GA12669@rhlx01.hs-esslingen.de>
 <1248748935.2560.669.camel@ymzhang>
 <4e5e476b0907280020x242d9ef7gfa05c3d7b66f941f@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Entering a deep C state can cause strange things to timers: some of
> them, especially tsc, become unreliable.

The Nehalem family CPU has a non-stop constant-frequency TSC.

The measurements that Yanmin quotes show that the TSC
is the lowest overhead timesource in the system.

thanks,
Len Brown, Intel Open Source Technology Center
