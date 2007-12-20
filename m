Return-Path: <linux-kernel-owner+w=401wt.eu-S1760867AbXLTMe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760867AbXLTMe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758421AbXLTMeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:34:16 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:56284 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758024AbXLTMeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:34:16 -0500
Subject: Re: Testing RAM from userspace / question about memmap= arguments
From: Jon Masters <jonathan@jonmasters.org>
To: Matthew Bloch <matthew@bytemark.co.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <fk8umh$n7o$1@ger.gmane.org>
References: <fk8umh$n7o$1@ger.gmane.org>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Thu, 20 Dec 2007 07:33:32 -0500
Message-Id: <1198154013.3205.124.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-12-18 at 17:06 +0000, Matthew Bloch wrote:

> I can see a few potential problems, but since my understanding of the
> low-level memory mapping is muddy at best, I won't speculate; I'd just
> appreciate any more expert views on whether this does work, or could be
> made to work.

Yo,

I don't think your testing approach is thorough enough. Clearly (knowing
your line of business - as a virtual machine provider), you want to do
pre-production testing as part of your provisioning. I would suggest
instead of using mlock() from userspace of simply writing a kernel
module that does this for every page of available memory.

You could script it via a minimal userland, containing only busybox,
some form of SSH implementation, whatever.

Jon.

P.S. With the above, you could also know which pages were faulty, an
consequently play with some of the bad RAM patches to exclude faulty
pages from the virtual machines running on a given host... ;-)


