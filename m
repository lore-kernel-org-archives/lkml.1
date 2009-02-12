Return-Path: <linux-kernel-owner+w=401wt.eu-S1759406AbZBLRva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406AbZBLRva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 12:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017AbZBLRvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 12:51:19 -0500
Received: from ns1.suse.de ([195.135.220.2]:34870 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbZBLRvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 12:51:19 -0500
Date: Thu, 12 Feb 2009 09:41:22 -0800
From: Greg KH <gregkh@suse.de>
To: Alex Chiang <achiang@hp.com>, Kay Sievers <kay.sievers@vrfy.org>,
       arjan@linux.intel.com, alex.williamson@hp.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: sysfs_add_one tells you _where_ the duplicate
	file is
Message-ID: <20090212174122.GA22301@suse.de>
References: <20090211202601.GC3402@ldl.fc.hp.com> <20090211223903.GA21100@suse.de> <20090212025655.GA6916@ldl.fc.hp.com> <20090212030227.GA4859@suse.de> <20090212070210.GB6916@ldl.fc.hp.com> <ac3eb2510902120105u17f5a0f9q13a228b9ff6ff3d4@mail.gmail.com> <20090212160257.GA18786@suse.de> <20090212173835.GB20654@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090212173835.GB20654@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 10:38:35AM -0700, Alex Chiang wrote:
> +	if (ret == -EEXIST) {
> +		char *path = kzalloc(PATH_MAX, GFP_KERNEL);

You forgot to check the return value of kzalloc().

Another try?

8th time's a charm?  :)

thanks,

greg k-h
