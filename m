Return-Path: <linux-kernel-owner+w=401wt.eu-S1761756AbXJYEP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761756AbXJYEP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 00:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbXJYEPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 00:15:17 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:51010 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbXJYEPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 00:15:15 -0400
Date: Thu, 25 Oct 2007 13:14:54 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bernhard Walle <bwalle@suse.de>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
Subject: Re: [patch 2/2] Use BOOTMEM_EXCLUSIVE for kdump
Message-ID: <20071025041454.GB25376@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bernhard Walle <bwalle@suse.de>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
References: <20071024163733.366829630@strauss.suse.de> <20071024163734.204144819@strauss.suse.de> <20071024210533.b919dba3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024210533.b919dba3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 09:05:33PM -0700, Andrew Morton wrote:
> On Wed, 24 Oct 2007 18:37:35 +0200 Bernhard Walle <bwalle@suse.de> wrote:
> > This patch uses the BOOTMEM_EXCLUSIVE, introduced in the previous patch,
> > to avoid conflicts while reserving the memory for the kdump carpture kernel
> > (crashkernel=).
> > 
> > Signed-off-by: Bernhard Walle <bwalle@suse.de>
> > 
> > ---
> >  arch/sh/kernel/setup.c     |   29 ++++++++++++++++++-----------
> >  arch/x86/kernel/setup_32.c |   28 ++++++++++++++++++----------
> >  arch/x86/kernel/setup_64.c |   35 +++++++++++++++++++++--------------
> 
> ia64 and powerpc support crash dump too?
> 
Not via a reserved bootmem area at least, which is what these patches
touch.

Acked-by: Paul Mundt <lethal@linux-sh.org>
