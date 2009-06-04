Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbZFDDt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbZFDDt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 23:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbZFDDts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 23:49:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:45779 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941AbZFDDts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 23:49:48 -0400
Date: Wed, 3 Jun 2009 20:40:38 -0700
From: Greg KH <gregkh@suse.de>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       garyhade@us.ibm.com, pbadari@us.ibm.com,
       "y-goto@jp.fujitsu.com" <y-goto@jp.fujitsu.com>, ebiederm@xmission.com
Subject: Re: sysfs_create_link_nowarn still remains (Was Re: mmotm
	2009-06-03-16-33 uploaded
Message-ID: <20090604034038.GA25656@suse.de>
References: <200906032353.n53Nre5r019806@imap1.linux-foundation.org> <20090604123813.96c2c5a9.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604123813.96c2c5a9.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 12:38:13PM +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 03 Jun 2009 16:33:52 -0700
> akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2009-06-03-16-33 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://git.zen-sources.org/zen/mmotm.git
> > 
> It seems sysfs_create_link_nowarn() is removed in linux-next.patch but
> driver/base/node.c still includes it.
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=c04fc586c1a480ba198f03ae7b6cbd7b57380b91
> 
> How should we fix it ? Folllowing is a quick hack for compile but ...
> should be clarified by memory hotplug guys.

I already dropped the removal patch, a few hours ago, look in the
linux-next and lkml archives :)

thanks,

greg k-h
