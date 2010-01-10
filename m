Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460Ab0AJQPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab0AJQPp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 11:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228Ab0AJQPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 11:15:44 -0500
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:49272 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752161Ab0AJQPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 11:15:43 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Jan 2010 11:15:43 EST
X-AuditID: 1209190c-b7ccdae00000276b-3b-4b49fc014239
Date: Sun, 10 Jan 2010 11:05:05 -0500 (EST)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>,
       linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: "m68k: Cleanup linker scripts using new linker script macros."
 and  old binutils (was: Re: [PATCH] m68k: Atari EtherNAT - Nicolas Pitre
 has a new  email address)
In-Reply-To: <10f740e81001100128q644cae1eg61c12b64f22e8398@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.1001101100540.1326@dr-wily.mit.edu>
References: <10f740e81001100128q644cae1eg61c12b64f22e8398@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jan 2010, Geert Uytterhoeven wrote:

> On Sun, Jan 10, 2010 at 05:56, Michael Schmitz
> <schmitz@biophys.uni-duesseldorf.de> wrote:
> > Backing out that commit on the top of the tree results in a bootable
> > 2.6.33-rc2 for me
> >
> > The order of symbols in the system map is different (as you would expect)
> > but I don't see what implicit assumption would be violated.
> 
> Tim, any clues? Michael is using gcc 3.3.6 and binutils 2.16.
> It works fine with my 4.1.2/2.18 vombo.

I think to debug this, we'll want to split the patch into the various 
small changes that make it up and determine which change caused the 
problem.  Michael, are you willing to do that debugging?  I'd be happy to 
generate for you a patch series of like a dozen patches broken out for 
bisecting if that'd help.

	-Tim Abbott
