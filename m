Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbZCXAQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbZCXAQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 20:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbZCXAQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 20:16:05 -0400
Received: from kroah.org ([198.145.64.141]:58662 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753692AbZCXAQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 20:16:03 -0400
Date: Mon, 23 Mar 2009 17:13:25 -0700
From: Greg KH <greg@kroah.com>
To: Theodore Tso <tytso@mit.edu>, Randy Dunlap <randy.dunlap@oracle.com>,
       Jan Kara <jack@suse.cz>, Greg KH <gregkh@suse.de>, mfasheh@suse.com,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, Dan Carpenter <error27@gmail.com>, mfasheh@suse.de,
       linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [stable] Linux 2.6.28.8 (ocfs2 build failure)
Message-ID: <20090324001325.GA1909@kroah.com>
References: <20090317012028.GA32410@kroah.com> <49C00787.6060401@oracle.com> <20090317205518.GA4442@kroah.com> <49C00FE9.9040407@oracle.com> <20090320221750.GA32416@kroah.com> <20090323024404.GA14082@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323024404.GA14082@mit.edu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 22, 2009 at 10:44:04PM -0400, Theodore Tso wrote:
> On Fri, Mar 20, 2009 at 03:17:50PM -0700, Greg KH wrote:
> > 
> > I tracked this down to commit 54dc90 in the 2.6.28.8 tree.
> > 
> > I've included it below.  Jan and Ted, any ideas on how to fix this
> > error?
> 
> 2.6.29 dropped the CONFIG_OCFS2_COMPAT_JBD option; if you enable it,
> causes a compile failure in 2.6.28.8.  This should fix it...

Can you send it in a format that I can apply it in?

thanks,

greg k-h
