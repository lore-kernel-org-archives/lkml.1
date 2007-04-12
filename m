Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbXDMQlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbXDMQlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 12:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbXDMQlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 12:41:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56989 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbXDMQlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 12:41:52 -0400
Date: Thu, 12 Apr 2007 15:58:43 -0700
From: Greg KH <greg@kroah.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 2/5] sysfs: Remove first pass at shadow directory
	support
Message-ID: <20070412225843.GA3713@kroah.com>
References: <m164898ncw.fsf@ebiederm.dsl.xmission.com> <m11wix8n74.fsf@ebiederm.dsl.xmission.com> <m1wt0p78k5.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1wt0p78k5.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2007 at 10:48:42AM -0600, Eric W. Biederman wrote:
> 
> While shadow directories appear to be a good idea, the current scheme
> of controlling their creation and destruction outside of sysfs appears
> to be a locking and maintenance nightmare in the face of sysfs directories
> dynamically coming and going.  Which can now occur for directories containing
> network devices when CONFIG_SYSFS_DEPRECATED is not set.
> 
> This patch removes everything from the initial shadow directory support
> that allowed the shadow directory creation to be controlled at a higher
> level.  So except for a few bits of sysfs_rename_dir everything from
> commit b592fcfe7f06c15ec11774b5be7ce0de3aa86e73 is now gone.

Can you rebase patches 2-5 on the latest -mm?  Tejun redid the whole
sysfs internals which pretty much means that this patch series doesn't
apply anymore :(

thanks,

greg k-h
