Return-Path: <linux-kernel-owner+w=401wt.eu-S1754946AbZKCGvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbZKCGvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 01:51:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbZKCGvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 01:51:08 -0500
Received: from gollum.grokthis.net ([206.251.38.24]:47151 "EHLO
	gollum.grokthis.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbZKCGvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 01:51:07 -0500
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Nov 2009 01:51:07 EST
X-Spam-Flag: NO
X-Spam-Score: -0.738
Subject: Re: FatELF patches...
From: Eric Windisch <eric@grokthis.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 03 Nov 2009 01:43:39 -0500
Message-Id: <1257230619.5063.42.camel@eric-desktop.grokthis.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, I apologize if this message gets top-posted or otherwise
improperly threaded, as I'm not currently a subscriber to the list (I
can no longer handle the daily traffic).  I politely ask that I be CC'ed
on any replies.

In response to Alan's request for a FatELF use-case, I'll submit two of
my own.

I have customers which operate low-memory x86 virtual machine instances.
Until recently, these ran with as little as 64MB of RAM.  Many customers
have chosen 32-bit distributions for these systems, but would like the
flexibility of scaling beyond 4GB of memory.  These customers would like
the choice of migrating to 64-bit without having to reinstall their
distribution.

Furthermore, I'm involved in several "cloud computing" initiatives,
including interoperability efforts.  There has been discussion of
assuring portability of virtual machine images across varying
infrastructure services.  I could see how FatELF could be part of a
solution to this problem, enabling a single image to function against
host services running a variety of architectures.

As for negatives: I'm running ZFS which now supports deduplication, so
this might potentially eliminate my own concerns in regard to storage.
Eventually, Btrfs will provide this capability under Linux directly. The
networking isn't much of an issue either, as I have my own mirrors for
the popular distributions.  While this isn't the typical end-user
environment, it might be a typical environment for companies facing the
unique problems FatELF solves.

I concede that there are a number of ways that solutions to these
problems might be implemented, and FatELF binaries might not be the
optimal solution.  Regardless, I do feel that use cases do exist, even
if there are questions and concerns about the implementation.

-- 
Regards,
Eric Windisch

