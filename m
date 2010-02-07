Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab0BGScK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 13:32:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753203Ab0BGScI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 13:32:08 -0500
Date: Sun, 7 Feb 2010 10:32:02 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Joel Becker <Joel.Becker@oracle.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.33-rc7
In-Reply-To: <20100207102016.GH3416@mail.oracle.com>
Message-ID: <alpine.LFD.2.00.1002071029040.3829@localhost.localdomain>
References: <alpine.LFD.2.00.1002061422430.3829@localhost.localdomain> <alpine.LFD.2.00.1002061445210.3829@localhost.localdomain> <20100207102016.GH3416@mail.oracle.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 7 Feb 2010, Joel Becker wrote:
> 
> 	When I grab tarballs, I only grab .gz.  Bandwidth isn't a
> problem (3 minutes versus four on my DSL, I still switch over to another
> screen and check back).  But .bz2 unpacks very slowly in the
> environments I'm usually grabbing a tarball for.  I save more time
> unpacking .gz than I do downloading .bz2.

Ok, there seems to be a fair number of people who prefer .gz files for 
whatever reason. 

So I guess I'll stay with the current setup. It's only (somebody elses) 
diskspace, after all.

Another option might be to stop generating the .bz2 files, of course. 
Anybody who cares more about network bandwidth than CPU use (ie people who 
would seem to prefer bz2) would be better off using git instead, which 
packs things _way_ better, by virtue of being much more incremental.

But at that point, I'm not even involved any more, because that bz2 
generation is entirely scripted at kernel.org.

				Linus
