Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbZKTVU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbZKTVU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444AbZKTVU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:20:56 -0500
Received: from kroah.org ([198.145.64.141]:50533 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760AbZKTVUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:20:54 -0500
Date: Fri, 20 Nov 2009 12:13:55 -0800
From: Greg KH <greg@kroah.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 06/15] sysfs: Fix locking and factor out
 sysfs_sd_setattr
Message-ID: <20091120201355.GA30590@kroah.com>
References: <m1pr7tmqb4.fsf@fess.ebiederm.org>
 <1257665233-12468-6-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257665233-12468-6-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 07, 2009 at 11:27:04PM -0800, Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Cleanly separate the work that is specific to setting the
> attributes of a sysfs_dirent from what is needed to update
> the attributes of a vfs inode.
> 
> Additionally grab the sysfs_mutex to keep any nasties from
> surprising us when updating the sysfs_dirent.
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Due to the extended attr work for sysfs that went into Linus's tree
recently, this patch doesn't apply at all anymore.

I've applied the first 5 to my tree, care to respin the other 10 and
resend them?

thanks,

greg k-h
