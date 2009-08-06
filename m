Return-Path: <linux-kernel-owner+w=401wt.eu-S1756270AbZHFRA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbZHFRA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 13:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756204AbZHFRAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 13:00:25 -0400
Received: from emroute3.ornl.gov ([160.91.4.110]:33225 "EHLO emroute3.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755342AbZHFRAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 13:00:24 -0400
X-Greylist: delayed 2363 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Aug 2009 13:00:24 EDT
Date: Thu, 06 Aug 2009 12:20:58 -0400
From: David Dillow <dave@thedillows.org>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based /dev
In-reply-to: <87ljlxhrnr.fsf@basil.nowhere.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, gregkh@suse.de,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Message-id: <1249575658.19886.8.camel@lap75545.ornl.gov>
MIME-version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10)
Content-type: text/plain
Content-transfer-encoding: 7bit
References: <20090805171513.GA10443@kroah.com>
 <20090805192037.19c54c4d@lxorguk.ukuu.org.uk>
 <20090805182805.GA7534@kroah.com> <20090805185136.GA21442@kroah.com>
 <87ljlxhrnr.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 17:46 +0200, Andi Kleen wrote:
> Greg KH <greg@kroah.com> writes:
> >
> > It makes the userspace boot process much simpler and easier to maintain,
> > as well as providing a way to handle rescue disks and images trivially,
> > and it makes the kernel _less_ dependant on the early userspace bootup
> > scripts.
> 
> As a initrd less kernel user I can really only agree: getting rid
> of the udev-in-initrd requirement would be a big step forward
> in usability. Typically I always have to pre populate 
> a on disk /dev manually first to get my kernels to boot.

If you use mount by label or UUID, you still need udev (or other tools)
in the initrd to find the right disk, correct? And for distros that want
to support that, does this really reduce the amount of code in the
initrd?
