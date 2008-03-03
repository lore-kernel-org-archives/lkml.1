Return-Path: <linux-kernel-owner+w=401wt.eu-S1761561AbYCDDXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761561AbYCDDXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 22:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755119AbYCDDXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 22:23:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:8335 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918AbYCDDXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 22:23:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,441,1199692800"; 
   d="scan'208";a="528225268"
Subject: Re: 2.6.25-rc regression: kernel panic on boot
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kay.sievers@vrfy.org
In-Reply-To: <20080303224259.GA27008@suse.de>
References: <1204500349.10256.171.camel@acpi-hp-zz.sh.intel.com>
	 <20080303224259.GA27008@suse.de>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 02:33:47 +0800
Message-Id: <1204569227.10256.174.camel@acpi-hp-zz.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-03-04 at 06:42 +0800, Greg KH wrote:
> On Mon, Mar 03, 2008 at 07:25:49AM +0800, Zhang, Rui wrote:
> > Hi, all,
> >
> > kernel panic on boot when I try to run 2.6.25-rc1 and later, but
> 2.6.24-rc8 boots okay.
> > The result of git-bisect shows that
> > edfaa7c36574f1bf09c65ad602412db9da5f96bf is first bad commit.
> >
> > The git-bisect-result and the dmesg log when the kernel panic are
> attached.
> > Any help on this please? :)
> 
> Are you using LVM?  If so, please either upgrade your userspace/initrd
> stuff, or enable CONFIG_SYSFS_DEPCRECATED
> 
Yes, enabling CONFIG_SYSFS_DEPRECATED works for me. :)

thanks,
rui

