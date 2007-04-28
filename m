Return-Path: <linux-kernel-owner+w=401wt.eu-S1030506AbXD1TSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030506AbXD1TSf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030501AbXD1TSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:18:34 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:43214 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1030490AbXD1TSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:18:31 -0400
Date: Sat, 28 Apr 2007 11:43:13 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>, Oliver Neukum <oliver@neukum.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <200704281235.37102.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.63.0704281139500.11638@qynat.qvtvafvgr.pbz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> 
 <200704271150.55701.oliver@neukum.org>  <Pine.LNX.4.64.0704271303260.925@sbz-30.cs.Helsinki.FI>
 <200704281235.37102.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007, Rafael J. Wysocki wrote:
> On Friday, 27 April 2007 12:12, Pekka J Enberg wrote:
>> The problem with writing in the kernel is obvious: we need to add new code
>> to the kernel for compression, encryption, and userspace interaction
>> (graphical progress bar) that are important for user experience.
>
> Yes, and that's why we wanted to introduce the userland part.  The problem
> with this approach, as it's turned out, is that the userland part must be a
> very specialized piece of software, really careful of what it's doing, mainly
> because of the inability to checkpoint filesystems.  If we could checkpoint
> filesystems and were able to unfreeze the user space after creating the
> snapshot without the risk of corrupting filesystems in the restore phase,
> the userland part could be much simpler (even as simple as Linus suggested).

this sounds like a really good argument for having a useable userspace running. 
we already have the LVM snapshot code in the kernel, so we have the pieces 
available to protect the filesystems, we just need to figure out how to put them 
togeather. (the simpliest way would be to make a new suspend package that 
required the user to use LVM so that snapshots are available, but this is also 
the most disruptive approach)

David Lang
