Return-Path: <linux-kernel-owner+w=401wt.eu-S1755815AbZDNJoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbZDNJoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755610AbZDNJnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:43:11 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:21127 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471AbZDNJnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:43:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hs1suO3k0UEMtY5Tr8r0mbXWp3WX4kS2uM4FlyiVbPus/LVLjOmHu3FzHeC3y7GIFY
         00spZWPvQv/bqxnJlgBYe5qt89zM7zCUEvNkGMqR22uInN4IRkGj4v8XojIoZ5Q/t8b5
         RM9V4yQxJoJ3z/TpoG3FwZu2oc4G+FZyA5WZI=
Date: Tue, 14 Apr 2009 18:43:03 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext2: fix missing mutex_unlock in error path
Message-ID: <20090414094303.GA10129@localhost.localdomain>
References: <20090414073631.GA4145@localhost.localdomain> <20090414074356.GC398@duck.suse.cz> <20090414093545.GA10092@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414093545.GA10092@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 06:35:45PM +0900, Akinobu Mita wrote:
> On Tue, Apr 14, 2009 at 09:43:57AM +0200, Jan Kara wrote:
> >   Thanks for the patch but I already have this patch in my quota tree from
> > Dan Carpenter...
> 
> Oh, I should have checked your tree.
> BTW, JFS still have same problem in jfs_quota_write() 

It's already fixed in JFS tree...
