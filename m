Return-Path: <linux-kernel-owner+w=401wt.eu-S932595AbYBHDLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595AbYBHDLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 22:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755886AbYBHDLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 22:11:38 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50888 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754324AbYBHDLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 22:11:37 -0500
Date: Thu, 7 Feb 2008 19:11:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [GIT PATCH] final SCSI updates for 2.6.24 merge window
In-Reply-To: <20080207184606.03b28a9c.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0802071909350.2896@woody.linux-foundation.org>
References: <1202432206.3171.53.camel@localhost.localdomain> <20080207184606.03b28a9c.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Feb 2008, Andrew Morton wrote:
> 
> Sob.  Can we please merge "Convert SG from nopage to fault"?

Heh. I just took it directly then.

I think it's more of a VM patch than a SCSI patch anyway, so I don't think 
you really should even have tried to push it through the SCSI tree.

It's not like we ever do the low-level FS changes for VFS issues through 
the FS maintainers anyway (ie you sent me all those iget/read_inode things 
directly rather than trying to go through each filesystem). I don't think 
this is any different, really.

		Linus
