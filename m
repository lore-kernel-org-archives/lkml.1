Return-Path: <linux-kernel-owner+w=401wt.eu-S1757098AbZCYX0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbZCYX0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 19:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbZCYX0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 19:26:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752991AbZCYX0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 19:26:02 -0400
Date: Wed, 25 Mar 2009 16:23:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Theodore Tso <tytso@mit.edu>
cc: David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <20090325220530.GR32307@mit.edu>
Message-ID: <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <49C88C80.5010803@krogh.cc> <72dbd3150903241200v38720ca0x392c381f295bdea@mail.gmail.com>
 <20090325183011.GN32307@mit.edu> <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain> <20090325220530.GR32307@mit.edu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Mar 2009, Theodore Tso wrote:
> > 
> > The problem being that unlike the ratio, there's no sane default value 
> > that you can at least argue is not _entirely_ pointless.
> 
> Well, if the maximum time that someone wants to wait for an fsync() to
> return is one second, and the RAID array can write 100MB/sec

How are you going to tell the kernel that the RAID array can write 
100MB/s?

The kernel has no idea.

			Linus
