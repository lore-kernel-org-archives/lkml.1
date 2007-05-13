Return-Path: <linux-kernel-owner+w=401wt.eu-S1759297AbXEMSck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297AbXEMSck (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 14:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757684AbXEMSce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 14:32:34 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:22148 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757616AbXEMScd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 14:32:33 -0400
Message-ID: <464759BF.5050505@msgid.tls.msk.ru>
Date: Sun, 13 May 2007 22:32:31 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Dan Aloni <da-x@monatomic.org>
CC: Stephen Hemminger <shemminger@linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] allow kernel module exclusion on load
References: <20070513132517.GA14038@localdomain> <20070513092352.18cd80de@freepuppy> <20070513171555.GA27920@localdomain> <46475324.7050303@msgid.tls.msk.ru> <20070513182226.GA8658@localdomain>
In-Reply-To: <20070513182226.GA8658@localdomain>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Aloni wrote:
[]
> Yes, I guess a shell script can always look at /proc/cmdline with
> relatively minimal complexity.
> 
> Anyway, it all boils down to whether there's a developer demand 
> for a userspace-independent way of blacklisting modules. Let's see 
> if more people post their opinion so we can determine.

The real problem here - again IMHO - is the complete lack of more-or-less
standard boot sequence.  Every distro invents their own intramfs with
unique recognized command-line arguments.

And kinit/klibc doesn't really help here, because it's too low-level.

/mjt

P.S.  I wonder why certain emails are duplicated on LKML.  An example
is my previous email in this thread - I received two copies of it
from linux-kernel-owner@vger.
