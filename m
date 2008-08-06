Return-Path: <linux-kernel-owner+w=401wt.eu-S1763553AbYHFDoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763553AbYHFDoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 23:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbYHFDoC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 23:44:02 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598AbYHFDoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 23:44:00 -0400
Subject: Re: [RFC 0/5] [TALPA] Intro to a linux interface for on access
	scanning
From: Eric Paris <eparis@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: malware-list@lists.printk.net, linux-kernel@vger.kernel.org
In-Reply-To: <874p5y7tw0.fsf@basil.nowhere.org>
References: <1217883616.27684.19.camel@localhost.localdomain>
	 <874p5y7tw0.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 23:43:54 -0400
Message-Id: <1217994234.27684.227.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-06 at 04:35 +0200, Andi Kleen wrote:
> Eric Paris <eparis@redhat.com> writes:
> 
> > 5. Fine-grained caching
> > -----------------------
> > It is necessary to select which filesystems can be safely cached and
> > which must not be. For example it is not a good idea to allow caching of
> > network filesystems because their content can be changed invisibly. Disk
> > based and some virtual filesystems can be cached safely on the other
> > hand.
> 
> Actually local disk file systems can be changed invisibly to the VFS too by 
> directly writing to the block device. This does not change the
> page cache, but the on disk copy and when a page is pruned from
> RAM and reloaded VFS will see the new contents without knowing
> about any change. How would you stop that in your
> proposal? I assume you could always require a special LKM that
> forbids block writes for anything mounted, but that has other problems 
> too and one wuld need to be extremly careful of holes in
> such a protection scheme (e.g. overlapping partitions) 

I didn't consider it.  Most likely at the end of the day the finding
will be, "if you can write directly to the block device you already won
since there as so many other things you can do to subvert the system."

Admittedly its the first technical point brought up on list that I
didn't consider at all (lots of other things brought up on list that
need more thought that weren't exactly technical details, don't let me
seem like I'm downplaying those)

-Eric

