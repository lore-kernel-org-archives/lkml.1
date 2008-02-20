Return-Path: <linux-kernel-owner+w=401wt.eu-S1756439AbYBTER7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439AbYBTER7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 23:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbYBTERu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 23:17:50 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:46195 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbYBTERt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 23:17:49 -0500
Message-ID: <47BBA9D0.4030000@oracle.com>
Date: Tue, 19 Feb 2008 20:17:20 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] sysfs: small header file cleanup
References: <20080218162216.ee1501fd.randy.dunlap@oracle.com> <alpine.DEB.1.00.0802181629180.15109@chino.kir.corp.google.com> <alpine.DEB.1.00.0802181650140.21008@chino.kir.corp.google.com> <20080219144053.f0506b87.randy.dunlap@oracle.com> <alpine.DEB.1.00.0802191738070.20797@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.00.0802191738070.20797@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> Convert sysfs_remove_bin_file() to have a return type of 'void' for
> !CONFIG_SYSFS configurations.  Also removes unnecessary colons from empty
> void functions.
> 
> Cc: Randy Dunlap <randy.dunlap@oracle.com>

Reviewed-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks, David.

> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  include/linux/sysfs.h |    9 ++-------
>  1 files changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
> --- a/include/linux/sysfs.h
> +++ b/include/linux/sysfs.h
> @@ -131,7 +131,6 @@ static inline int sysfs_create_dir(struct kobject *kobj)
>  
>  static inline void sysfs_remove_dir(struct kobject *kobj)
>  {
> -	;
>  }
>  
>  static inline int sysfs_rename_dir(struct kobject *kobj, const char *new_name)
> @@ -160,7 +159,6 @@ static inline int sysfs_chmod_file(struct kobject *kobj,
>  static inline void sysfs_remove_file(struct kobject *kobj,
>  				     const struct attribute *attr)
>  {
> -	;
>  }
>  
>  static inline int sysfs_create_bin_file(struct kobject *kobj,
> @@ -169,10 +167,9 @@ static inline int sysfs_create_bin_file(struct kobject *kobj,
>  	return 0;
>  }
>  
> -static inline int sysfs_remove_bin_file(struct kobject *kobj,
> -					struct bin_attribute *attr)
> +static inline void sysfs_remove_bin_file(struct kobject *kobj,
> +					 struct bin_attribute *attr)
>  {
> -	return 0;
>  }
>  
>  static inline int sysfs_create_link(struct kobject *kobj,
> @@ -183,7 +180,6 @@ static inline int sysfs_create_link(struct kobject *kobj,
>  
>  static inline void sysfs_remove_link(struct kobject *kobj, const char *name)
>  {
> -	;
>  }
>  
>  static inline int sysfs_create_group(struct kobject *kobj,
> @@ -195,7 +191,6 @@ static inline int sysfs_create_group(struct kobject *kobj,
>  static inline void sysfs_remove_group(struct kobject *kobj,
>  				      const struct attribute_group *grp)
>  {
> -	;
>  }
>  
>  static inline int sysfs_add_file_to_group(struct kobject *kobj,


-- 
~Randy
