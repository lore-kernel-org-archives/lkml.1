Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbYDUXS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbYDUXS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 19:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbYDUXST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 19:18:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50851 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbYDUXSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 19:18:18 -0400
Date: Tue, 22 Apr 2008 00:18:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Sparc
Message-ID: <20080421231815.GS27459@ZenIV.linux.org.uk>
References: <20080421.153231.108090227.davem@davemloft.net> <alpine.LFD.1.10.0804211608570.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804211608570.2779@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 04:10:00PM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 21 Apr 2008, David Miller wrote:
> > 
> > This performs the scheduled removal of Solaris and SunOS
> > system call for sparc, much to the chagrin of Al Viro
> > and others :-) (in particular, that asm/namei.h crud can
> > now die)
> 
> Hmm. I think this is sad. The fact is, Solaris/SunOS is the de-facto 
> standard for Sparc. Which makes me think that not emulating them is a real 
> capability loss. 
> 
> I realize that the code may be painful, but still...

FWIW, two things I _really_ want dead and gone are
	* timod (or full rewrite of that animal; current one is badly racy
and plays fast and loose with way too many place in VFS guts)
	* altroot (use chroot, damnit, and bind whatever you need in there)

Other than that...  No preferences, really.
