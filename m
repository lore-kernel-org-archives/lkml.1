Return-Path: <linux-kernel-owner+w=401wt.eu-S1758324AbYFZMuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324AbYFZMuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758731AbYFZMgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:36:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757821AbYFZMgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:36:15 -0400
Date: Thu, 26 Jun 2008 08:35:18 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove CONFIG_EXPERIMENTAL from kdump
Message-ID: <20080626123518.GA3878@redhat.com>
References: <20080625221635.GD32344@redhat.com> <1214465001-12338-1-git-send-email-bwalle@suse.de> <20080626012337.a73c91d2.akpm@linux-foundation.org> <20080626102803.2a1a46cd@halley.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080626102803.2a1a46cd@halley.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 10:28:03AM +0200, Bernhard Walle wrote:
> * Andrew Morton [2008-06-26 01:23]:
> > >  
> > >  config PROC_VMCORE
> > >          bool "/proc/vmcore support (EXPERIMENTAL)"
> > > -        depends on PROC_FS && EXPERIMENTAL && CRASH_DUMP
> > > +        depends on PROC_FS && CRASH_DUMP
> > >  	default y
> > >          help
> > >          Exports the dump image of crashed kernel in ELF format.
> > 
> > What about powerpc, sh and ia64?
> 
> At least for ia64 I wouldn't consider it as experimental. Don't know
> about SH and PPC. But should we mark it as EXPERIMENTAL on all
> platforms only because some "exotic" (at least SH) platforms have kdump
> not very long implemented?

It has been present long enough on ia64 and ppc64. Only new entry seems
to be SH. I would think of leaving it EXPERIMENTAL only on SH.

Thanks
Vivek
