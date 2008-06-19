Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbYFSKAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbYFSKAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 06:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbYFSJ7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 05:59:55 -0400
Received: from ping.pong.ch ([212.103.71.101]:59215 "EHLO ping.pong.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205AbYFSJ7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 05:59:54 -0400
Date: Thu, 19 Jun 2008 11:59:52 +0200
From: Gaudenz Steinlin <gaudenz@debian.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       486798@bugs.debian.org, josejx@gentoo.org
Subject: Re: [PATCH] restore export of handle_mm_fault for Mac on Linux
Message-ID: <20080619095952.GB28907@soziologie.ch>
References: <20080618101402.GF15718@soziologie.ch> <20080618114906.GA23788@infradead.org> <18521.846.628816.525787@cargo.ozlabs.ibm.com> <20080618125131.GA2097@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080618125131.GA2097@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 08:51:31AM -0400, Christoph Hellwig wrote:
> On Wed, Jun 18, 2008 at 10:45:02PM +1000, Paul Mackerras wrote:
> > > Has been rejected a few times.  An now that we actually have kvm
> > > for powerpc in tree MOL should just merge with that project and
> > > do the right things in tree instead of beeing a really hacky
> > > module subverting the VM.
> > 
> > We don't have KVM for the "classic" 32-bit PowerPC processors, only
> > for the 44x family.  And doing KVM for the classic 32-bit processors
> > would probably involve just as much hackery as MOL. :)
> 
> I don't think so.  Doing it properly in-tree will mean that it is
> 
>   a) properly reviewed
>   b) means we can do the major VM bits in the kernel without these
>      really stupid exports
> 
> Have you looked at MOL recently?  It's more than disgusting.
> 
> And in addition to these issue we do of course as policy not add
> random hooks in the kernel tree for out of tree stuff.  Especially
> for hacks like this that don't even have the intention to get merged.

This is not true anymore. See my other message to this thread. Joseph
Jezak is working on a mergeable module.

Gaudenz

-- 
Ever tried. Ever failed. No matter.
Try again. Fail again. Fail better.
~ Samuel Beckett ~
