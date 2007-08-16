Return-Path: <linux-kernel-owner+w=401wt.eu-S1761104AbXHPPbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761104AbXHPPbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 11:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754943AbXHPPbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 11:31:22 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35783 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1763226AbXHPPbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 11:31:10 -0400
Date: Thu, 16 Aug 2007 11:31:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Rene Herman <rene.herman@gmail.com>
cc: Kyle Moffett <mrmacman_g4@mac.com>, Salikh Zakirov <salikh@gmail.com>,
       Junio C Hamano <gitster@pobox.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       <linux-pm@lists.linux-foundation.org>, <git@vger.kernel.org>
Subject: Re: [linux-pm] Re: Storing Maintainers info around the kernel tree
In-Reply-To: <46C469A5.8020003@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0708161128540.3757-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Aug 2007, Rene Herman wrote:

> > It would be much easier to put in the "kernel/somesubsys" directory a 
> > Maintainers file which has:
> 
> It's ofcourse possible, but note that if we want this stuff to be minimally 
> manual, moving files around (and deleting them) then requires editing these 
> actual in-tree files via a tool.
> 
> With the properties deleting files just requires deleting any file-specific 
> properties alongside which is trivial since those are linked from the file.
> 
> Moving stuff works by building a list of all properties that are set on the 
> source starting at the source and destination's highest shared parent 
> directory and then reconstructing this list at the destination, striking 
> properties off the list that are already set at the destination.
> 
> Adding properties, alongside added files or after the fact, could be done 
> via standard patch submissals via the kind of "meta-diff" that already 
> exists for "git move".
> 
> I really believe this stuff should be meta-data -- and these properties as 
> outlined work well it seems.

Please remember that not everybody uses git.  The MAINTAINERS data 
should be available in the kernel source itself.

(Maybe your suggestion is consistent with this -- I simply wanted to 
raise the point.)

Alan Stern

