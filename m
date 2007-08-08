Return-Path: <linux-kernel-owner+w=401wt.eu-S1764093AbXHHHTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764093AbXHHHTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756989AbXHHHMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:12:52 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:7295 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341AbXHHHMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:12:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=sKiqWwhFtfG7gX7X+N1OcDp5vpCo9UN6Um45F7+f4Rv/2axLSM26j9KAwdSdjmniKGM+MgBmhJCWfRTa8rtkx29F7NLlPCqcrNSwW5ZajuYtdpgMxAqQauoUi5uaPyvdKHzwwttuCDaBe+NWCULLMt9gm3gM0SS23op9e7yJrf4=
Date: Wed, 8 Aug 2007 16:12:41 +0900
From: Tejun Heo <htejun@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 06/25] sysfs: Simplify readdir.
Message-ID: <20070808071241.GZ13674@htj.dyndns.org>
References: <11860582832964-git-send-email-htejun@gmail.com> <m1643rkqb6.fsf@ebiederm.dsl.xmission.com> <m11wefkq88.fsf_-_@ebiederm.dsl.xmission.com> <m1wsw7jbml.fsf_-_@ebiederm.dsl.xmission.com> <m1sl6vjbjw.fsf_-_@ebiederm.dsl.xmission.com> <m1odhjjbij.fsf_-_@ebiederm.dsl.xmission.com> <m1k5s7jbh9.fsf_-_@ebiederm.dsl.xmission.com> <m1fy2vjbf9.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1fy2vjbf9.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 03:13:14PM -0600, Eric W. Biederman wrote:
> 
> At some point someone wrote sysfs_readdir to insert a cursor
> into the list of sysfs_dirents to ensure that sysfs_readdir would
> restart properly.  That works but it is complex code and tends
> to be expensive.
> 
> The same effect can be achieved by keeping the sysfs_dirents in
> inode order and using the inode number as the f_pos.  Then
> when we restart we just have to find the first dirent whose inode
> number is equal or greater then the last sysfs_dirent we attempted
> to return.
> 
> Removing the sysfs directory cursor also allows the remove of
> all of the mysterious checks for sysfs_type(sd) != 0.   Which
> were nonbovious checks to see if a cursor was in a directory list.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Tejun Heo <htejun@gmail.com>

-- 
tejun
