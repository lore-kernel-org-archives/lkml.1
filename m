Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbZHFPqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbZHFPqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 11:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbZHFPqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 11:46:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34156 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138AbZHFPqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 11:46:01 -0400
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       gregkh@suse.de, Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based /dev
From: Andi Kleen <andi@firstfloor.org>
References: <20090805171513.GA10443@kroah.com>
	<20090805192037.19c54c4d@lxorguk.ukuu.org.uk>
	<20090805182805.GA7534@kroah.com> <20090805185136.GA21442@kroah.com>
Date: Thu, 06 Aug 2009 17:46:00 +0200
In-Reply-To: <20090805185136.GA21442@kroah.com> (Greg KH's message of "Wed, 5 Aug 2009 11:51:36 -0700")
Message-ID: <87ljlxhrnr.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:
>
> It makes the userspace boot process much simpler and easier to maintain,
> as well as providing a way to handle rescue disks and images trivially,
> and it makes the kernel _less_ dependant on the early userspace bootup
> scripts.

As a initrd less kernel user I can really only agree: getting rid
of the udev-in-initrd requirement would be a big step forward
in usability. Typically I always have to pre populate 
a on disk /dev manually first to get my kernels to boot.

> And then there's the great reason Kay previously stated, "if sysfs has
> all the names, numbers, and device properties, why would we need complex
> userspace to have the nodes?"

Exactly.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
