Return-Path: <linux-kernel-owner+w=401wt.eu-S1755632AbXHBBIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632AbXHBBIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 21:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbXHBBI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 21:08:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58625 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbXHBBI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 21:08:26 -0400
Date: Wed, 1 Aug 2007 18:10:56 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <htejun@gmail.com>
Cc: ebiederm@xmission.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu
Subject: Re: [PATCH 1/7] sysfs: fix locking in sysfs_lookup() and
	sysfs_rename_dir()
Message-ID: <20070802011056.GA27131@kroah.com>
References: <11858769082982-git-send-email-htejun@gmail.com> <1185876908509-git-send-email-htejun@gmail.com> <20070802002900.GA16784@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070802002900.GA16784@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 05:29:00PM -0700, Greg KH wrote:
> On Tue, Jul 31, 2007 at 07:15:08PM +0900, Tejun Heo wrote:
> > sd children list walking in sysfs_lookup() and sd renaming in
> > sysfs_rename_dir() were left out during i_mutex -> sysfs_mutex
> > conversion.  Fix them.
> > 
> > Signed-off-by: Tejun Heo <htejun@gmail.com>
> 
> Ok, to apply this, it messes with Eric's further patches for the shadow
> directory stuff.  But since it looks like you and Eric seem to have
> worked something else in that area, I'll drop Eric's patches for now, as
> that's the safest thing.
> 
> Eric, is that ok?

Oh nevermind, it looks like you already took care of this with the later
patches...

thanks,

greg k-h
