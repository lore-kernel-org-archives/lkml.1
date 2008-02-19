Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732AbYBSQoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbYBSQoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 11:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbYBSQoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 11:44:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35898 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbYBSQoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 11:44:14 -0500
Date: Tue, 19 Feb 2008 08:38:10 -0800
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@lst.de>, David Howells <dhowells@redhat.com>
Subject: Re: [RFC 00/11] possible debugfs/libfs consolidation
Message-ID: <20080219163810.GC3718@suse.de>
References: <20080219040435.825494460@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219040435.825494460@arndb.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 05:04:35AM +0100, Arnd Bergmann wrote:
> I noticed that there is a lot of duplication in pseudo
> file systems, so I started looking into how to consolidate
> them. I ended up with a largish rework of the structure
> of libfs and moving almost all of debugfs in there as well.
> 
> As an example, I also have patches that reduce debugfs,
> securityfs and usbfs to the point where they are mostly
> thin wrappers around libfs, with large comment blocks.
> Other file systems could be changed in the same way, but
> I first like to see if people agree that I'm on the right
> track.

I like the idea, and have no objection to these patches at all.  Please
feel free to test them and send them again :)

thanks,

greg k-h
