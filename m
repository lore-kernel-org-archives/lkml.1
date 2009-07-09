Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbZGIUOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbZGIUOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 16:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbZGIUOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 16:14:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:37721 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632AbZGIUOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 16:14:21 -0400
Date: Thu, 9 Jul 2009 13:12:57 -0700
From: Greg KH <gregkh@suse.de>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: jmorris@namei.org, sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on
 sysfs files, directories, and symlinks.
Message-ID: <20090709201257.GB27124@suse.de>
References: <1247074106-23405-1-git-send-email-dpquigl@tycho.nsa.gov>
 <20090709151803.GB24302@suse.de>
 <1247159613.4398.215.camel@localhost>
 <20090709175250.GB26378@suse.de>
 <1247167738.4398.229.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247167738.4398.229.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 03:28:58PM -0400, David P. Quigley wrote:
> On Thu, 2009-07-09 at 10:52 -0700, Greg KH wrote:
> > On Thu, Jul 09, 2009 at 01:13:33PM -0400, David P. Quigley wrote:
> > > The issue is that there really aren't any LSM hooks to accommodate that.
> > > I have a few LSM hooks for the Labeled NFS work which could be used for
> > > this but it still requires us to store the full xattr value somewhere
> > > and referencing it in the sysfs_dirent structure.
> > 
> > A void pointer would handle that properly, right?
> 
> A void pointer would suffice if we wanted to store the opaque blob. My
> argument is that storing that blob is too heavy weight memory wise.

You could use that void pointer to store your id with no memory
difference at all, so why would it be "heavy weight"?  It shoud be
identical, right?

thanks,

greg k-h
