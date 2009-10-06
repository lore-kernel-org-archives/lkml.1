Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbZJFB6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbZJFB6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 21:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbZJFB6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 21:58:08 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:50340 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbZJFB6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 21:58:07 -0400
Date: Mon, 05 Oct 2009 21:57:15 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
In-reply-to: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>
Message-id: <alpine.LFD.2.00.0910052140100.309@localhost.localdomain>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> do you mean -rc2 as in the Makefile (ie really -rc1) or -rc2 as in the 
> tagged release.

We have a similar problem with the period between, say, 2.6.X and 
2.6.Y-rc1.  The Makefile still says 2.6.X, yet during the 2.6.Y
merge window the tree is very different from 2.6.X.

This confuses things like my scripts that take a source tree tarball,
and (re)generate config files for build testing based on the tags
in the Makefile.  There is no way for the scripts to know the
post 2.6.X tree not the same as 2.6.X itself, the new configs
overwrite the old, overwrite the old results etc.

I think that BenH also had troubles with this issue and pointed
it out a while back, but you were not convinced at the time that
it was a problem worth solving.

This could be clarified if you update Makefile on the 1st commit
after 2.6.X is frozen to simply be 2.6.Y-merge or 2.6.Y-rc0
or something.  Anything but 2.6.X.

thanks,
-Len Brown, Intel Open Source Technolgy Center

