Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbYIZVvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbYIZVvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 17:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbYIZVvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 17:51:42 -0400
Received: from [198.145.64.141] ([198.145.64.141]:40176 "EHLO coco.kroah.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750885AbYIZVvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 17:51:42 -0400
Date: Fri, 26 Sep 2008 14:48:47 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Eric Paris <eparis@redhat.com>, david@lang.hm, bunk@kernel.org,
       peterz@infradead.org, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, hch@infradead.org, andi@firstfloor.org,
       viro@ZenIV.linux.org.uk, arjan@infradead.org
Subject: Re: [malware-list] [RFC] 0/11 fanotify: fscking all notifiction
	and file access system (intended for antivirus scanning and file
	indexers)
Message-ID: <20080926214847.GA9592@kroah.com>
References: <1222463220.2872.193.camel@localhost.localdomain> <20080926223404.7c4894df@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080926223404.7c4894df@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 10:34:04PM +0100, Alan Cox wrote:
> > It all starts when 'something' registers a group.  Registering a group
> > is as simple as 'echo "open_grp 50 0x10" > /security/fanotify/register.
> 
> I thought the operation was usually called "mkdir" which also nicely
> deals with races and exclusion.

So does configfs.  Eric, why not use that instead, it sounds like it
will work here nicely.

thanks,

greg k-h
