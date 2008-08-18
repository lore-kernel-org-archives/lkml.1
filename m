Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbYHRRPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbYHRRPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 13:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbYHRRPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 13:15:41 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:51442 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751502AbYHRRPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 13:15:40 -0400
Subject: Re: [Bug #11330] int3: 0000 in tsc_read_refs when using powernow_k7
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Daniel Hecht <dhecht@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       Mikko Vinni <mmvinni@yahoo.com>,
       the arch/x86 maintainers <x86@kernel.org>
In-Reply-To: <sNRO-BDDjQL.A.v-E.dazpIB@albercik>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
	 <sNRO-BDDjQL.A.v-E.dazpIB@albercik>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 18 Aug 2008 10:15:40 -0700
Message-Id: <1219079740.13032.14.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-16 at 12:02 -0700, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).

There is this fix 

commit d554d9a4295dd0595d12eeccbc55d1f495b15176
Author: Marcin Slusarz <marcin.slusarz@gmail.com>
Date:   Mon Aug 11 00:07:44 2008 +0200

    x86, tsc: fix section mismatch warning

which is in x86/tip-master which fixes this issue. 
I don't see the fix in the mainline tree yet. 

Maybe Ingo, has it queued, for upstream ?
Ingo, other than a section mismatch warning it also fixes a real bug.

Thanks,
Alok

> 

> 
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=11330
> Subject         : int3: 0000 in tsc_read_refs when using powernow_k7
> Submitter       : Mikko Vinni <mmvinni@yahoo.com>
> Date            : 2008-08-14 04:21 (3 days old)
> Patch           : http://bugzilla.kernel.org/show_bug.cgi?id=11330#c2
> 
> 

