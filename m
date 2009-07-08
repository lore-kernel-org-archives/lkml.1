Return-Path: <linux-kernel-owner+w=401wt.eu-S1757821AbZGHSpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821AbZGHSpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 14:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754947AbZGHSp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 14:45:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33261 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817AbZGHSp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 14:45:26 -0400
Date: Wed, 8 Jul 2009 14:44:18 -0400
From: Dave Jones <davej@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Joao Correia <joaomiguelcorreia@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 1/3] Increase lockdep limits: MAX_STACK_TRACE_ENTRIES
Message-ID: <20090708184418.GB16090@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Joao Correia <joaomiguelcorreia@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	=?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>
References: <a5d9929e0907070825j1dda6584t93196e2730dedc5c@mail.gmail.com> <1246980836.9777.5.camel@twins> <a5d9929e0907070838q7ed3306du3bb7880e47d7207b@mail.gmail.com> <1246981444.9777.11.camel@twins> <a5d9929e0907070850v72cd4da4y1cbbb10fddebd575@mail.gmail.com> <1246982101.9777.15.camel@twins> <20090708172248.GB2521@redhat.com> <1247078164.16156.18.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247078164.16156.18.camel@laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 08:36:04PM +0200, Peter Zijlstra wrote:
 > Looking at a lockdep dump hch gave me I can see that that is certainly
 > possible, I see tons of very deep callchains.
 > 
 > /me wonders if we're getting significantly deeper..
 > 
 > OK I guess we can raise this one, does doubling work? That would get us
 > around 29 entries per trace..
 > 
 > Also, Dave do these distro init scrips still load every module on the
 > planet or are we more sensible these days?
 > module load/unload cycles are really bad for lockdep resources.

34 modules get loaded on the system I saw the trace on. 
(That's from lsmod after fulling booting up). I'm not aware of any
module unloading that happens during bootup.
 
	Dave

