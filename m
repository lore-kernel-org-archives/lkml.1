Return-Path: <linux-kernel-owner+w=401wt.eu-S1756640AbYABPAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbYABPAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 10:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbYABPAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 10:00:06 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55284 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176AbYABPAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 10:00:04 -0500
Date: Wed, 2 Jan 2008 20:29:08 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Quentin Barnes <qbarnes@gmail.com>, linux-kernel@vger.kernel.org,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH] [CFT] Code clarification patch to Kprobes arch code
Message-ID: <20080102145908.GA6527@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <b70efdcb0712310929y1bf871eah2adb531a7ed89673@mail.gmail.com> <20080101151943.GE4434@elte.hu> <20080102044353.GA7027@in.ibm.com> <20080102123355.GB11208@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080102123355.GB11208@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 01:33:55PM +0100, Ingo Molnar wrote:
> 
> * Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:
> 
> > > Signed-off-by: Quentin Barnes <qbarnes@gmail.com>
> > > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > 
> > Tested on x86.
> > 
> > Acked-by: Ananth N Mavinakayahanalli <ananth@in.ibm.com>
> 
> thanks Ananth, i've updated the patch.

Hi Ingo,

> btw., do you have some script that i could use to test kprobes 
> functionality? Right now the only time i notice kprobes regressions is 
> when randconfig picks up CONFIG_NET_TCPPROBE=y which activates kprobes.
> 
> It would be so much nicer if kprobes had some runs-during-bootup kind of 
> quick self-test, with all the important functionality unit-tested. Like 
> lib/locking-selftest.c, or CONFIG_RCU_TORTURE_TEST=y.

The simplest way to do a basic sanity check is build the kprobes samples/
and try them out. We have one sample each to test kprobes, kretprobes
and jprobes. This should serve the purpose.

I had posted patches for the same sometime back
(http://marc.info/?l=linux-kernel&m=119297044801420&w=2), but they needed
some rework to fix a build break on sparc64
(http://marc.info/?l=linux-kernel&m=119735423212298&w=2).

I will rebase the patchset against the latest mm and repost soon...

Ananth
