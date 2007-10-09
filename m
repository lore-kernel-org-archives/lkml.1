Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbXJIX3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbXJIX3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 19:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756540AbXJIX3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 19:29:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59775 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477AbXJIX3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 19:29:20 -0400
Date: Tue, 9 Oct 2007 16:28:04 -0700
From: Greg KH <greg@kroah.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <htejun@gmail.com>,
       ebiederm@xmission.com, stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 3/4] sysfs: divorce sysfs from kobject and driver
	model
Message-ID: <20071009232804.GA22010@kroah.com>
References: <11902755392688-git-send-email-htejun@gmail.com> <20070925221736.GA3566@kroah.com> <46FB956B.8000205@gmail.com> <20071005061812.GA16914@kroah.com> <4705EF30.8010002@gmail.com> <20071009112901.6d4fa19d@gondolin> <20071009222638.GD21228@kroah.com> <adar6k3g9iw.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adar6k3g9iw.fsf@cisco.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 04:20:39PM -0700, Roland Dreier wrote:
>  > > - relaying implementation details to userspace so that they cannot be
>  > > easily changed. We would need to allow kobjects not showing up in sysfs
>  > > and making symlinks a sysfs facility not relying on kobjects to help
>  > > there.
>  > 
>  > Huh?  Why would you want a kobject to not show up in sysfs?
> 
> I think the text you replied to explained it perfectly: becase you
> don't want internal implementation details to be exposed the userspace
> and become an unchangeable part of the kernel/userspace interface.

But a kobject represents "something" in the kernel.  If it's there, then
it shows up in sysfs.  But if it isn't, or it changes somehow, then it
no longer is in sysfs, which is fine, and your userspace tools have to
be able to handle that by virtue of the rules of how to use sysfs from
userspace.

thanks,

greg k-h
