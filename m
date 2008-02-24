Return-Path: <linux-kernel-owner+w=401wt.eu-S1759742AbYBXSBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759742AbYBXSBi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 13:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759407AbYBXSBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 13:01:09 -0500
Received: from cantor.suse.de ([195.135.220.2]:58662 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759392AbYBXSBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 13:01:08 -0500
Date: Sun, 24 Feb 2008 10:00:18 -0800
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       David Howells <dhowells@redhat.com>
Subject: Re: [RFC 01/11] add generic versions of debugfs file operations
Message-ID: <20080224180018.GA13234@suse.de>
References: <20080219040435.825494460@arndb.de> <20080219040828.415218298@arndb.de> <20080223122444.GM27894@ZenIV.linux.org.uk> <200802241146.08360.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802241146.08360.arnd@arndb.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 11:46:07AM +0100, Arnd Bergmann wrote:
> On Saturday 23 February 2008, Al Viro wrote:
> 
> > Ewww - caps, \n...  BTW, \0 is pointless here - simple_read_from_buffer() will
> > not access it with these arguments)...
> 
> > ... 
> 
> > Please, check the length; sloppy input grammar is a bad idea.  Hell, at the
> > very least you want -EINVAL if input is not recognized...
> 
> Ok, these two come straight from debugfs, but of course I can fix them
> anyway. Should I do a fix for debugfs in 2.6.25 first, or rather do a
> patch on top of the libfs rework?

I'll gladly take a patch to debugfs for it :)

thanks,

greg k-h
