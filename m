Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab0BKXn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 18:43:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54277 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757297Ab0BKXn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 18:43:26 -0500
Date: Thu, 11 Feb 2010 15:42:21 -0800
From: Greg KH <gregkh@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       "Tejun Heo <tj@kernel.org> Neil Brown" <neilb@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] sysfs: Use sysfs_attr_init and sysfs_bin_attr_init
 on dynamic attributes
Message-ID: <20100211234221.GA10498@suse.de>
References: <4B728CFE.40208@kernel.org>
 <m1sk992bji.fsf@fess.ebiederm.org>
 <20100210230544.GA678@suse.de>
 <m1ocjwwob1.fsf@fess.ebiederm.org>
 <4B73671E.2050105@kernel.org>
 <m1bpfvxt67.fsf_-_@fess.ebiederm.org>
 <m14olnxt3s.fsf_-_@fess.ebiederm.org>
 <m1ljezwean.fsf_-_@fess.ebiederm.org>
 <m1hbpnwe7i.fsf_-_@fess.ebiederm.org>
 <m1d40bwe5i.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d40bwe5i.fsf_-_@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 03:23:05PM -0800, Eric W. Biederman wrote:
> 
> These are the non-static sysfs attributes that exist on
> my test machine.  Fix them to use sysfs_attr_init or
> sysfs_bin_attr_init as appropriate.   It simply requires
> making a sysfs attribute present to see this.  So this
> is a little bit tedious but otherwise not too bad.

Can we document this in the sysfs_attr_init kerneldoc documentation that
you add for this new function?

thanks,

greg k-h
