Return-Path: <linux-kernel-owner+w=401wt.eu-S1756299AbXHBBLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299AbXHBBLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 21:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbXHBBLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 21:11:10 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37941 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbXHBBLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 21:11:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: Tejun Heo <htejun@gmail.com>, ebiederm@xmission.com, gregkh@suse.de,
       linux-kernel@vger.kernel.org, satyam@infradead.org,
       cornelia.huck@de.ibm.com, stern@rowland.harvard.edu
Subject: Re: [PATCH 1/7] sysfs: fix locking in sysfs_lookup() and sysfs_rename_dir()
References: <11858769082982-git-send-email-htejun@gmail.com>
	<1185876908509-git-send-email-htejun@gmail.com>
	<20070802002900.GA16784@kroah.com>
Date: Wed, 01 Aug 2007 19:10:31 -0600
In-Reply-To: <20070802002900.GA16784@kroah.com> (Greg KH's message of "Wed, 1
	Aug 2007 17:29:00 -0700")
Message-ID: <m1tzrin3lk.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> On Tue, Jul 31, 2007 at 07:15:08PM +0900, Tejun Heo wrote:
>> sd children list walking in sysfs_lookup() and sd renaming in
>> sysfs_rename_dir() were left out during i_mutex -> sysfs_mutex
>> conversion.  Fix them.
>> 
>> Signed-off-by: Tejun Heo <htejun@gmail.com>
>
> Ok, to apply this, it messes with Eric's further patches for the shadow
> directory stuff.  But since it looks like you and Eric seem to have
> worked something else in that area, I'll drop Eric's patches for now, as
> that's the safest thing.
>
> Eric, is that ok?

Sounds good.  With a little luck I should have something working in a couple
of hours and then I can see about getting a tree with both my patches
and Tejun.  So I will probably rebase on top of Tejun's latest patches.

Eric
