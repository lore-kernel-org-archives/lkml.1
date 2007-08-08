Return-Path: <linux-kernel-owner+w=401wt.eu-S932923AbXHHHqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923AbXHHHqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762604AbXHHHqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:46:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:17194 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765888AbXHHHqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:46:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=jDNJma0EBncGh+8sjYIqqkV7v1O8fg/qpyrRQM1pcx/JADdSlKc5rq63HleBMaNSsX9N29btFDuyk1COdafuD+7PmM+NDi85GLqpkhfDi0wW/EfsMuWDyioaamCskmqVWx8L7OyT2kuiD1hLNEB74o0Wd375NH6qYjYFMe6677c=
Date: Wed, 8 Aug 2007 16:45:59 +0900
From: Tejun Heo <htejun@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 10/25] sysfs: Rewrite sysfs_get_dentry in terms of __sysfs_get_dentry
Message-ID: <20070808074559.GD13674@htj.dyndns.org>
References: <m11wefkq88.fsf_-_@ebiederm.dsl.xmission.com> <m1wsw7jbml.fsf_-_@ebiederm.dsl.xmission.com> <m1sl6vjbjw.fsf_-_@ebiederm.dsl.xmission.com> <m1odhjjbij.fsf_-_@ebiederm.dsl.xmission.com> <m1k5s7jbh9.fsf_-_@ebiederm.dsl.xmission.com> <m1fy2vjbf9.fsf_-_@ebiederm.dsl.xmission.com> <m1bqdjjbcf.fsf_-_@ebiederm.dsl.xmission.com> <m17io7jba4.fsf_-_@ebiederm.dsl.xmission.com> <m13ayvjb82.fsf_-_@ebiederm.dsl.xmission.com> <m1y7gnhwm4.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1y7gnhwm4.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 03:18:27PM -0600, Eric W. Biederman wrote:
> 
> This removes the last major user of s_dentry and makes
> the locking in sysfs_get_dentry much simpler.  Hopefully
> leading to more readable and maintainable code.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Tejun Heo <htejun@gmail.com>

-- 
tejun
