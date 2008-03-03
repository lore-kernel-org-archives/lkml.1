Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbYCCWnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbYCCWnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 17:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbYCCWnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 17:43:07 -0500
Received: from mx1.suse.de ([195.135.220.2]:46139 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbYCCWnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 17:43:06 -0500
Date: Mon, 3 Mar 2008 14:42:59 -0800
From: Greg KH <gregkh@suse.de>
To: "Zhang, Rui" <rui.zhang@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kay.sievers@vrfy.org
Subject: Re: 2.6.25-rc regression: kernel panic on boot
Message-ID: <20080303224259.GA27008@suse.de>
References: <1204500349.10256.171.camel@acpi-hp-zz.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204500349.10256.171.camel@acpi-hp-zz.sh.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 07:25:49AM +0800, Zhang, Rui wrote:
> Hi, all,
> 
> kernel panic on boot when I try to run 2.6.25-rc1 and later, but 2.6.24-rc8 boots okay.
> The result of git-bisect shows that
> edfaa7c36574f1bf09c65ad602412db9da5f96bf is first bad commit.
> 
> The git-bisect-result and the dmesg log when the kernel panic are attached.
> Any help on this please? :)

Are you using LVM?  If so, please either upgrade your userspace/initrd
stuff, or enable CONFIG_SYSFS_DEPCRECATED

thanks,

greg k-h
