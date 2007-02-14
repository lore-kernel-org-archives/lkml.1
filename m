Return-Path: <linux-kernel-owner+w=401wt.eu-S1750985AbXBNB2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750985AbXBNB2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 20:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbXBNB2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 20:28:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbXBNB2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 20:28:47 -0500
Date: Tue, 13 Feb 2007 17:27:32 -0800
From: Greg KH <gregkh@suse.de>
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH debugfs: implement symbolic links
Message-ID: <20070214012732.GA9023@suse.de>
References: <45D19D72.4050009@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D19D72.4050009@de.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 12:13:54PM +0100, Peter Oberparleiter wrote:
> From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
> 
> debugfs: implement symbolic links
> 
> Implement a new function debugfs_create_symlink() which can be used
> to create symbolic links in debugfs. This function can be useful
> for people moving functionality from /proc to debugfs (e.g. the
> gcov-kernel patch).

You aren't really creating debugfs symlinks from /sys/kernel/debug/ to
the /proc directory are you?  That's pretty insane...

Otherwise I have no objection to this, I'll add it to my queue...

thanks,

greg k-h
