Return-Path: <linux-kernel-owner+w=401wt.eu-S1763039AbXHHI5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763039AbXHHI5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 04:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbXHHI5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 04:57:12 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:2356 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbXHHI5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 04:57:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=qTJeB6Wh7JaotnlaUn7SCKNAxUeDqBzvUasRX6pWnEmtXzdzJpXKpLtZ2IWz0vZazvTTxYHoq3UVq7WpV/VSEpuB9DnUclhrJnNbwTIq84XJgyXeGXfasSSNY94QV42qdsD1noT6dcjLETZjk86bJwKuWmTBGgXDt/ZwlEnMcuw=
Date: Wed, 8 Aug 2007 17:57:03 +0900
From: Tejun Heo <htejun@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 19/25] sysfs: sysfs_get_dentry add a sb parameter
Message-ID: <20070808085703.GK13674@htj.dyndns.org>
References: <m1y7gnhwm4.fsf_-_@ebiederm.dsl.xmission.com> <m1tzrbhwkc.fsf_-_@ebiederm.dsl.xmission.com> <m1ps1zhwhp.fsf_-_@ebiederm.dsl.xmission.com> <m1lkcnhwfu.fsf_-_@ebiederm.dsl.xmission.com> <m1hcnbhwcy.fsf_-_@ebiederm.dsl.xmission.com> <m1d4xzhwb2.fsf_-_@ebiederm.dsl.xmission.com> <m18x8nhw8r.fsf_-_@ebiederm.dsl.xmission.com> <m14pjbhw6y.fsf_-_@ebiederm.dsl.xmission.com> <m1zm13ghlh.fsf_-_@ebiederm.dsl.xmission.com> <m1vebrghjg.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1vebrghjg.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 03:29:23PM -0600, Eric W. Biederman wrote:
> 
> In preparation for multiple mounts of sysfs add a superblock parameter to
> sysfs_get_dentry.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> @@ -827,7 +829,7 @@ struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd)
>  	 */
>  	dentry = NULL;
>  	cur = sd;
> -	while (!(dentry = __sysfs_get_dentry(sysfs_sb, cur))) {
> +	while (!(dentry = __sysfs_get_dentry(sb, cur))) {

It's probably better to add @sb to __sysfs_get_dentry() here too.
That will make things look clearer.

Thanks.

-- 
tejun
