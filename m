Return-Path: <linux-kernel-owner+w=401wt.eu-S1763070AbXHHIYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763070AbXHHIYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 04:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754097AbXHHIYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 04:24:39 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:14914 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbXHHIYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 04:24:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=TUP/y6NP0LC2lVJV3qXiaG6EQ6pBQIkKxty5HwvHwisy82SWW4DKj+WT1kHpsv0L6KEONjh+YmFb8IIe9X9GO9AeWj6yTptKUIqnNmdtdQKmu0OMcKw418bMPvYEso7zsDBUOrCB1ATuo56+JW2sj9Zh4OuH+CmFYArLUfL0cvE=
Date: Wed, 8 Aug 2007 17:24:29 +0900
From: Tejun Heo <htejun@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 13/25] sysfs: Simply sysfs_get_dentry
Message-ID: <20070808082429.GF13674@htj.dyndns.org>
References: <m1odhjjbij.fsf_-_@ebiederm.dsl.xmission.com> <m1k5s7jbh9.fsf_-_@ebiederm.dsl.xmission.com> <m1fy2vjbf9.fsf_-_@ebiederm.dsl.xmission.com> <m1bqdjjbcf.fsf_-_@ebiederm.dsl.xmission.com> <m17io7jba4.fsf_-_@ebiederm.dsl.xmission.com> <m13ayvjb82.fsf_-_@ebiederm.dsl.xmission.com> <m1y7gnhwm4.fsf_-_@ebiederm.dsl.xmission.com> <m1tzrbhwkc.fsf_-_@ebiederm.dsl.xmission.com> <m1ps1zhwhp.fsf_-_@ebiederm.dsl.xmission.com> <m1lkcnhwfu.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1lkcnhwfu.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 03:22:13PM -0600, Eric W. Biederman wrote:
> 
> Now that we know the sysfs tree structure cannot change under us
> simplfy sysfs_get_dentry.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Tejun Heo <htejun@gmail.com>

It might be better to have sysfs_get_dentry_locked() and
sysfs_get_dentry() so that the latter can be used from
sysfs_update/chmod_file().

-- 
tejun
