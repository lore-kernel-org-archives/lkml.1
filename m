Return-Path: <linux-kernel-owner+w=401wt.eu-S1751878AbZCKUto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbZCKUto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 16:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbZCKUsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 16:48:53 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:40393 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730AbZCKUsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 16:48:52 -0400
Date: Wed, 11 Mar 2009 14:48:34 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] PCI fixes for 2.6.29
Message-ID: <20090311204834.GJ25995@parisc-linux.org>
References: <20090311043659.GC25995@parisc-linux.org> <alpine.LFD.2.00.0903111220200.32478@localhost.localdomain> <20090311201337.GI25995@parisc-linux.org> <86802c440903111336v7b5c3e3jc5bb3afd9da8f42e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440903111336v7b5c3e3jc5bb3afd9da8f42e@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 01:36:05PM -0700, Yinghai Lu wrote:
> please don't use that one. and use "pci: don't disable too many HT MSI
> mapping -v4" instead

I already said I'm not comfortable applying a patch that intrusive at
this stage of -rc7.  I don't understand it nearly well enough, and given
that v1 ended up *not* solving the problem, and neither did v2 or v3,
I'm not convinced you understand it well enough either.  I think v4 is
appropriate for applying during the 2.6.30 merge window.

If you can find someone who really does understand it to review it and
agree it's OK for a post-rc7 merge, I'll consider changing my mind.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
