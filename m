Return-Path: <linux-kernel-owner+w=401wt.eu-S934460AbXHHGvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934460AbXHHGvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 02:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755911AbXHHGvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 02:51:11 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:39477 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397AbXHHGvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 02:51:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Wdy3MsR58mJNPI8S6uPQUetjN74q2zWRnBHCTsFpKBB/lOs3NbXdWFxBV5e6SakdBgM0NvnzxQhLBBCMJQMNOhOs0ZxcKWPr4tcK/KXUZlpQJ26Ix9q4kTHyIpTCzzOiuJKOSgA6TdAS7K2c9OigrTlf7IYrTwFpQ1cXG23uNeQ=
Date: Wed, 8 Aug 2007 15:51:03 +0900
From: Tejun Heo <htejun@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 04/25] sysfs: Make sysfs_mount static
Message-ID: <20070808065103.GX13674@htj.dyndns.org>
References: <11860582832964-git-send-email-htejun@gmail.com> <m1643rkqb6.fsf@ebiederm.dsl.xmission.com> <m11wefkq88.fsf_-_@ebiederm.dsl.xmission.com> <m1wsw7jbml.fsf_-_@ebiederm.dsl.xmission.com> <m1sl6vjbjw.fsf_-_@ebiederm.dsl.xmission.com> <m1odhjjbij.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1odhjjbij.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 03:11:16PM -0600, Eric W. Biederman wrote:
> 
> This patch modifies the users of sysfs_mount to use sysfs_root
> instead (which is what they are looking for).  It then
> makes sysfs_mount static to keep people from using it
> by accident.
> 
> The net result is slightly faster and cleaner code.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Tejun Heo <htejun@gmail.com>

--
tejun
