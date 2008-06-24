Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbYFXDIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbYFXDIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 23:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbYFXDIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 23:08:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757412AbYFXDIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 23:08:07 -0400
Date: Mon, 23 Jun 2008 20:07:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Robert Hancock <hancockr@shaw.ca>
cc: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Hans de Goede <j.w.r.degoede@hhs.nl>, Zhang Rui <rui.zhang@intel.com>,
       Jean Delvare <khali@linux-fr.org>, linux-acpi@vger.kernel.org,
       lm-sensors@lm-sensors.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.26-rc] ACPI Thermal Zone driver breaks lm-sensors 2
 userspace
In-Reply-To: <48605935.5070407@shaw.ca>
Message-ID: <alpine.LFD.1.10.0806232004480.2926@woody.linux-foundation.org>
References: <fa.4PGqX9CuLbgiTimfCcon+PlAMxk@ifi.uio.no> <fa.PWu620xEt5OlYdOezvRtQriuNjM@ifi.uio.no> <48605935.5070407@shaw.ca>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 23 Jun 2008, Robert Hancock wrote:

> Mark M. Hoffman wrote:
> > 
> > 1) The bug is in libsensors (2.10), not the kernel.
> 
> This doesn't matter. Breaking userspace in such a fashion is severely frowned
> upon unless essentially unavoidable, even if it is just triggering a bug.

I do tend to agree. If it used to work, it should continue to work, even 
if it wasn't _meant_ to work.

That's not always 100% possible, but the fact is, neither is updating user 
space always possible. The kernel needs to try its best to maintain stable 
interfaces, and no, "..but the interface was broken" is _not_ an 
acceptable excuse for unbreaking it if it causes problems.

> > - but more importantly -
> > 
> > 2) This patch is broken.
> 
> You didn't indicate what was wrong with the patch.

Yes. Leaving everybody wondering whether it's just an opinionated 
expression of the former problem, or whether there is a real and 
understandable reason why it was NACK'ed.

		Linus
