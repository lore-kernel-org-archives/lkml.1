Return-Path: <linux-kernel-owner+w=401wt.eu-S1765563AbXHHHrC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765563AbXHHHrC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:47:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933099AbXHHHqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:46:46 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:17194 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933060AbXHHHqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:46:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=S3WW1Vu89fZOEkM70UZz4iz19dZa58789eopV38fQByFfY9DQtG4vKo6MqOKUjNjssI/jofQPArbfSCMkALuUWDdqMzaHDW6B5J9EH7PuuKbIfLcDzsAb1hmfoy46WjDphIdsLIISchatDka6a1qFuNa9itDcfiJDjL4GyDChqw=
Date: Wed, 8 Aug 2007 16:46:37 +0900
From: Tejun Heo <htejun@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 11/25] sysfs: Remove s_dentry
Message-ID: <20070808074637.GE13674@htj.dyndns.org>
References: <m1wsw7jbml.fsf_-_@ebiederm.dsl.xmission.com> <m1sl6vjbjw.fsf_-_@ebiederm.dsl.xmission.com> <m1odhjjbij.fsf_-_@ebiederm.dsl.xmission.com> <m1k5s7jbh9.fsf_-_@ebiederm.dsl.xmission.com> <m1fy2vjbf9.fsf_-_@ebiederm.dsl.xmission.com> <m1bqdjjbcf.fsf_-_@ebiederm.dsl.xmission.com> <m17io7jba4.fsf_-_@ebiederm.dsl.xmission.com> <m13ayvjb82.fsf_-_@ebiederm.dsl.xmission.com> <m1y7gnhwm4.fsf_-_@ebiederm.dsl.xmission.com> <m1tzrbhwkc.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1tzrbhwkc.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 03:19:31PM -0600, Eric W. Biederman wrote:
> 
> The only uses of s_dentry left are the code that maintains
> s_dentry and trivial users that don't actually need it.
> So this patch removes the s_dentry maintenance code and
> restructures the trivial uses to use something else.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Tejun Heo <htejun@gmail.com>

Nice clean up.  Thanks.

-- 
tejun
