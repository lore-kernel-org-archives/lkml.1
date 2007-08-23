Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703AbXHWFFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbXHWFFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 01:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbXHWFFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 01:05:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47474 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbXHWFFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 01:05:35 -0400
Date: Thu, 23 Aug 2007 10:48:23 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Dave Hansen <haveblue@us.ibm.com>
cc: greg@kroah.com, linux-kernel@vger.kernel.org,
       michal.k.k.piotrowski@gmail.com, akpm@linux-foundation.org
Subject: Re: [PATCH] make kobject dynamic allocation check use
 kallsyms_lookup()
In-Reply-To: <20070822220341.7926F241@kernel>
Message-ID: <alpine.LFD.0.999.0708231037040.2049@enigma.security.iitk.ac.in>
References: <20070822220341.7926F241@kernel>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,


On Wed, 22 Aug 2007, Dave Hansen wrote:
> 
> One of the top ten sysfs problems is that users use statically
> allocated kobjects.  This patch reminds them that this is a
> naughty thing.

Hmm, I might've missed previous discussion regarding this, but I'm
curious to know why using statically allocated kobjects is "naughty".
The code / warnings / printk messages below indicate this is only a
"silly/janitorial" issue?

The reason I ask is that if it is serious, there is no reason why this
check cannot be done at build-time itself, instead of this runtime
kludge in the kernel -- catching potential bugs at build-time is always
desirable. Modpost or some such tool can be taught to detect kobjects
allocated statically in vmlinux/modules -- or there can be other build-
time solutions, possibly. Have you considered such an approach?


Thanks,

Satyam
