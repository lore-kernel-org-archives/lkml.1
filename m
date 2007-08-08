Return-Path: <linux-kernel-owner+w=401wt.eu-S1765827AbXHHHgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765827AbXHHHgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755978AbXHHHg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:36:27 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:32174 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758436AbXHHHgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:36:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=P0xoSKJcstVwX1W3RmIlr9rj5yQ8GpFTWdCFWR1l8/UEx3YMK4xPkG2n3MJQwRZgO3wCjDfYj67v5lcbsC0uiU51KISxBq4EDxwoU0nMsl/Bp5UeveeXzue4KvCM94uhs0SImzXLstGPPJv90ihYhASC03uP5Nlccp3RhenPhkM=
Date: Wed, 8 Aug 2007 16:35:55 +0900
From: Tejun Heo <htejun@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 07/25] sysfs: Rewrite sysfs_drop_dentry.
Message-ID: <20070808073555.GA13674@htj.dyndns.org>
References: <11860582832964-git-send-email-htejun@gmail.com> <m1643rkqb6.fsf@ebiederm.dsl.xmission.com> <m11wefkq88.fsf_-_@ebiederm.dsl.xmission.com> <m1wsw7jbml.fsf_-_@ebiederm.dsl.xmission.com> <m1sl6vjbjw.fsf_-_@ebiederm.dsl.xmission.com> <m1odhjjbij.fsf_-_@ebiederm.dsl.xmission.com> <m1k5s7jbh9.fsf_-_@ebiederm.dsl.xmission.com> <m1fy2vjbf9.fsf_-_@ebiederm.dsl.xmission.com> <m1bqdjjbcf.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1bqdjjbcf.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 03:14:56PM -0600, Eric W. Biederman wrote:
> 
> Currently we find the dentry to drop by looking at sd->s_dentry.
> We can just as easily accomplish the same task by looking up the
> sysfs inode and finding all of the dentries from there, with the
> added bonus that we don't need to play with the sysfs_assoc_lock.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Great, Acked-by: Tejun Heo <htejun@gmail.com>

-- 
tejun
