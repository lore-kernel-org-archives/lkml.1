Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbYF0IQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbYF0IQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 04:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754243AbYF0IP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 04:15:59 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:27771 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754547AbYF0IP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 04:15:57 -0400
Date: Fri, 27 Jun 2008 17:13:09 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Bernhard Walle <bwalle@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove CONFIG_EXPERIMENTAL from kdump
Message-ID: <20080627081309.GA11284@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Vivek Goyal <vgoyal@redhat.com>, Bernhard Walle <bwalle@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20080625221635.GD32344@redhat.com> <1214465001-12338-1-git-send-email-bwalle@suse.de> <20080626012337.a73c91d2.akpm@linux-foundation.org> <20080626102803.2a1a46cd@halley.suse.de> <20080626123518.GA3878@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080626123518.GA3878@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 08:35:18AM -0400, Vivek Goyal wrote:
> On Thu, Jun 26, 2008 at 10:28:03AM +0200, Bernhard Walle wrote:
> > * Andrew Morton [2008-06-26 01:23]:
> > > >  
> > > >  config PROC_VMCORE
> > > >          bool "/proc/vmcore support (EXPERIMENTAL)"
> > > > -        depends on PROC_FS && EXPERIMENTAL && CRASH_DUMP
> > > > +        depends on PROC_FS && CRASH_DUMP
> > > >  	default y
> > > >          help
> > > >          Exports the dump image of crashed kernel in ELF format.
> > > 
> > > What about powerpc, sh and ia64?
> > 
> > At least for ia64 I wouldn't consider it as experimental. Don't know
> > about SH and PPC. But should we mark it as EXPERIMENTAL on all
> > platforms only because some "exotic" (at least SH) platforms have kdump
> > not very long implemented?
> 
> It has been present long enough on ia64 and ppc64. Only new entry seems
> to be SH. I would think of leaving it EXPERIMENTAL only on SH.
> 
Yes, kdump should remain EXPERIMENTAL on SH for the time being. It's only
been tested on a tiny subset of CPUs, and will need additional work for
the rest (as with kexec for that matter).
