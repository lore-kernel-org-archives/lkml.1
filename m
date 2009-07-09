Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbZGIRxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbZGIRxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 13:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZGIRx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 13:53:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:35116 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbZGIRx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 13:53:28 -0400
Date: Thu, 9 Jul 2009 10:50:49 -0700
From: Greg KH <gregkh@suse.de>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: Casey Schaufler <casey@schaufler-ca.com>, jmorris@namei.org,
       sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on
 sysfs files, directories, and symlinks.
Message-ID: <20090709175049.GA26378@suse.de>
References: <1247074106-23405-1-git-send-email-dpquigl@tycho.nsa.gov>
 <4A554B95.6070709@schaufler-ca.com>
 <1247160404.4398.218.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247160404.4398.218.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 01:26:44PM -0400, David P. Quigley wrote:
> I just read over Casey's comments again and I'm pretty sure we have a
> big misunderstanding here. From his initial response it seems that he
> thinks that I am exposing the secids to userspace as the way for setting
> the labels on files. That isn't true. We are still using the full string
> based labels for the userspace interface what the secid is used for is
> to allow the kernel to keep track of changes until the sysfs_dirent is
> destroyed. 

Ok, if Casey and others agree that this is the best solution, I'll take
it.

thanks,

greg k-h
