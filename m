Return-Path: <linux-kernel-owner+w=401wt.eu-S1761360AbZGIP1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761360AbZGIP1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 11:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760656AbZGIP1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 11:27:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:59525 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758987AbZGIP1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 11:27:43 -0400
Date: Thu, 9 Jul 2009 08:16:49 -0700
From: Greg KH <gregkh@suse.de>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: Casey Schaufler <casey@schaufler-ca.com>, jmorris@namei.org,
       sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on
 sysfs files, directories, and symlinks.
Message-ID: <20090709151649.GA24302@suse.de>
References: <1247074106-23405-1-git-send-email-dpquigl@tycho.nsa.gov>
 <4A554B95.6070709@schaufler-ca.com>
 <1247148306.4398.157.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247148306.4398.157.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 10:05:06AM -0400, David P. Quigley wrote:
> So are you proposing that we embed a variable length string in the
> sysfs_dirent structure because that sounds completely silly. It seems
> completely reasonable here to take the blob coming in and have the LSM
> turn it into a handle that is efficiently referenced by the
> sysfs_dirent. The problem here is that sysfs entries have no backing
> store at all which means everything we do will have to be added to
> sysfs_dirent. I'm pretty sure we don't want to be doing lifecycle
> management on strings inside this structure considering the only other
> string I see is marked const. If you have a better way of doing this I'm
> interested in hearing it but it doesn't seem reasonable to be storing
> the xattr itself in the sysfs_dirent. I'd like to hear what Greg thinks
> about that.

I think you all better agree on the proposed solution before I will
accept any changes to the sysfs core code :)

good luck,

greg k-h
