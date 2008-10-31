Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbYJaBMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbYJaBMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 21:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbYJaBMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 21:12:13 -0400
Received: from cinke.fazekas.hu ([195.199.244.225]:58998 "EHLO
	cinke.fazekas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbYJaBMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 21:12:12 -0400
Date: Fri, 31 Oct 2008 02:11:59 +0100 (CET)
From: Marton Balint <cus@fazekas.hu>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block:do_mounts - add device info to mount message
In-Reply-To: <20081029234356.aa1a3760.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0810301741320.2819@cinke.fazekas.hu>
References: <Pine.LNX.4.64.0810241309190.31107@cinke.fazekas.hu>
 <20081029234356.aa1a3760.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008, Andrew Morton wrote:

> On Fri, 24 Oct 2008 13:31:53 +0200 (CEST) Marton Balint <cus@fazekas.hu> wrote:
> 
> > Printing the minor and major number of the successfully mounted root 
> > device can be quite useful, the patch adds this piece of information 
> > to the "VFS: Mounted root..." message.
> > 
> 
> Can you expand upon "quite useful", please?  In what way is it useful? 
> A real-world example would help.

In the past, I used the root=... command line parameter to specify the 
root filesystem to the kernel. Now it seems that specifying it is not 
necessary. The kernel detects the root filesystem even if the kernel 
command line is empty. My root fs is on a raid1 device by the way, and I 
am not using initrd for the boot process.

If the kernel detects the root filesystem somehow, I think it should print 
out the result of this detection, otherwise I will not know which device 
has the root filesystem. Or is there an easy way to get this information 
on a running system? I had a quick look at the /proc and /sys filesystems, 
but haven't found anything useful there.

Regards,
  Marton
