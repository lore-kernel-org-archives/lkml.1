Return-Path: <linux-kernel-owner+w=401wt.eu-S1758579AbXK0GHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579AbXK0GHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 01:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbXK0GHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 01:07:43 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59070 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbXK0GHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 01:07:42 -0500
Date: Mon, 26 Nov 2007 21:47:26 -0800
From: Greg KH <greg@kroah.com>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>,
       Matt Tolentino <matthew.e.tolentino@intel.com>
Subject: Re: [PATCH 38/54] efivars: remove new_var and del_var files from
	sysfs
Message-ID: <20071127054726.GA1400@kroah.com>
References: <20071102235758.GA9803@kroah.com> <1194047972-9850-38-git-send-email-gregkh@suse.de> <20071116150116.GA8901@auslistsprd01.us.dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116150116.GA8901@auslistsprd01.us.dell.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 09:01:16AM -0600, Matt Domsch wrote:
> On Fri, Nov 02, 2007 at 04:59:16PM -0700, Greg Kroah-Hartman wrote:
> > WTF?  Passing binary structures into a sysfs file, expecting it to be in
> > the correct format/endianness?  That's just wrong on so many levels.
> > 
> > So, these files are deleted.  If you want to add them back, please do so
> > in configfs, or in debugfs.  Or use text strings, which is what sysfs is
> > only for.
> 
> 
> I have tested gregkh's patches tree, which includes this patch, the
> patch to put these back as binary blob interfaces, as well as other
> cleanups, on an Itanium2 system.  The efibootmgr userspace application
> continues to work as it did before this patch series, which I claim is
> success.  For the patches that touch drivers/firmware/efivars.c I can
> say:
> 
> Tested-by: Matt Domsch <Matt_Domsch@dell.com>

Great, thanks for doing this, I appreciate it.

greg k-h
