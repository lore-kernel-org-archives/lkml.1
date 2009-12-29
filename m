Return-Path: <linux-kernel-owner+w=401wt.eu-S1753779AbZL2Pof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbZL2Pof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbZL2Poa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:44:30 -0500
Received: from mail.gmx.net ([213.165.64.20]:33646 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753751AbZL2Po2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:44:28 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19nXjYYTNxnihaFF7Jugo0mHeb2eNMC0RFIaedWa3
	DAjTZ7pHI37pn+
Subject: Re: [Bug #14794] IP address assigned by DHCP is dropped after ~40
 seconds
From: Mike Galbraith <efault@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <srmJ8vMxKPH.A.MyC.uwhOLB@chimera>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
	 <srmJ8vMxKPH.A.MyC.uwhOLB@chimera>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Dec 2009 16:44:23 +0100
Message-Id: <1262101463.17659.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-29 at 16:28 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14794
> Subject		: IP address assigned by DHCP is dropped after ~40 seconds
> Submitter	: Márton Németh <nm127@freemail.hu>
> Date		: 2009-12-13 08:59 (17 days old)

This one was a userspace bug it seems.

<quote>
Comment #21 From Jarek Poplawski 2009-12-19 13:48:21 ------- 
On Sat, Dec 19, 2009 at 11:26:30AM +0100, Németh Márton wrote:
> I upgraded the Debian package "network-manager" from 0.6.6-3 to 0.7.2-2.
> The problem seems to be solved: the IP address is not dropped in 2.6.32
> and in 2.6.31. The conclusion is for me that a user-space program caused
> the problem, thanks for the hint.

Yes, Debian often fixes our bugs on time! ;-)

Thanks,
Jarek P.
</quote>

