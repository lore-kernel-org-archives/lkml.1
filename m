Return-Path: <linux-kernel-owner+w=401wt.eu-S1754392AbXH3EiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbXH3EiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 00:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbXH3EiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 00:38:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45108 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750710AbXH3EiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 00:38:06 -0400
Date: Wed, 29 Aug 2007 21:38:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] TASK_KILLED
In-Reply-To: <20070829204048.GQ14130@parisc-linux.org>
Message-ID: <alpine.LFD.0.999.0708292136530.25853@woody.linux-foundation.org>
References: <20070829204048.GQ14130@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 29 Aug 2007, Matthew Wilcox wrote:
> 
> I've long hated the non-killability of tasks accessing a dead
> NFS server.  Linus had an idea for fixing this way back in 2002:
> http://www.ussg.iu.edu/hypermail/linux/kernel/0208.0/0167.html which
> I've prototyped in this patch.

Hey, I obviously approve. And the patch looks simple.

Feel free to re-submit after 2.6.23 is out the door, I don't think 
anybody will really complain. Any NFS user will know why something like 
this can be really nice.

		Linus
