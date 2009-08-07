Return-Path: <linux-kernel-owner+w=401wt.eu-S1751491AbZHGEDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbZHGEDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 00:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbZHGEDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 00:03:03 -0400
Received: from mailhost18.gawab.com ([66.220.20.18]:56820 "HELO
	info3.gawab.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751027AbZHGEDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 00:03:03 -0400
X-Trusted: Whitelisted
From: Al Boldi <a1426z@gawab.com>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based /dev
Date: Fri, 7 Aug 2009 07:03:40 +0300
User-Agent: KMail/1.5
Cc: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, gregkh@suse.de,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
References: <20090805171513.GA10443@kroah.com> <200908062318.05478.a1426z@gawab.com> <20090806204911.GA14025@kroah.com>
In-Reply-To: <20090806204911.GA14025@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908070703.40706.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Aug 06, 2009 at 11:18:05PM +0300, Al Boldi wrote:
> > So really, if devtmpfs compares to udev speeds then this just looks like
> > a devfs comeback.  Remember, devfs was really slow.
>
> Again, there is no "speed" for devtmpfs on its own, the device nodes
> just appear when the devices are added to the kernel, the speed of that
> depends on the device discovery within the kernel, nothing else.

So on bootup this would mean a lot of discovery.

I think we could get some big speedup, by just dumping the possible 
non-realized device list on bootup, and then just refine it on physical 
access.  This could make devtmpfs an acceptable replacement to static /dev.


Thanks!

--
Al

