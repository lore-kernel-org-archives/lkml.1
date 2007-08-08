Return-Path: <linux-kernel-owner+w=401wt.eu-S1765798AbXHHHqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765798AbXHHHqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760115AbXHHHpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:45:53 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:42519 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764337AbXHHHpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:45:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=klPVRufmX1jgo9LAolLs4PtjNtqwM0YYoeANuvsX7hEEe55DN+c+FXci+IG7W9rvEoqOmk9QiQBByRVkJRyv9ra9Olrn2LTzHV1cb7oIQI7x2xgCIXcAHJGOAdduHMJtR710CMWeyjV7bTSyR06LV47DV16N2heeqObXt7AOko8=
Date: Wed, 8 Aug 2007 16:45:39 +0900
From: Tejun Heo <htejun@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 09/25] sysfs: Move sysfs_get_dentry below __sysfs_get_dentry
Message-ID: <20070808074539.GC13674@htj.dyndns.org>
References: <m1643rkqb6.fsf@ebiederm.dsl.xmission.com> <m11wefkq88.fsf_-_@ebiederm.dsl.xmission.com> <m1wsw7jbml.fsf_-_@ebiederm.dsl.xmission.com> <m1sl6vjbjw.fsf_-_@ebiederm.dsl.xmission.com> <m1odhjjbij.fsf_-_@ebiederm.dsl.xmission.com> <m1k5s7jbh9.fsf_-_@ebiederm.dsl.xmission.com> <m1fy2vjbf9.fsf_-_@ebiederm.dsl.xmission.com> <m1bqdjjbcf.fsf_-_@ebiederm.dsl.xmission.com> <m17io7jba4.fsf_-_@ebiederm.dsl.xmission.com> <m13ayvjb82.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m13ayvjb82.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 03:17:33PM -0600, Eric W. Biederman wrote:
> 
> sysfs_get_dentry is higher in fs/sysfs/dir.c then is needed and it the
> dependencies get simpler if we move it down in the file to where I
> have placed __sysfs_get_dentry.  So this patch just moves
> sysfs_get_dentry so code movement doesn't get confused with later code
> changes. 
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Tejun Heo <htejun@gmail.com>

-- 
tejun
