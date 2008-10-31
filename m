Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbYJaRMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbYJaRMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 13:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbYJaRMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 13:12:15 -0400
Received: from kroah.org ([198.145.64.141]:37625 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752163AbYJaRMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 13:12:14 -0400
Date: Fri, 31 Oct 2008 10:02:27 -0700
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: driver core: struct device - replace bus_id with dev_name(),
	dev_set_name()
Message-ID: <20081031170227.GC24826@kroah.com>
References: <1225327008.5970.27.camel@nga.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225327008.5970.27.camel@nga.site>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 01:36:48AM +0100, Kay Sievers wrote: index 5437ac0..c9c214d 100644
> --- a/include/linux/kobject.h
> +++ b/include/linux/kobject.h
> @@ -72,6 +72,8 @@ struct kobject {
>  
>  extern int kobject_set_name(struct kobject *kobj, const char *name, ...)
>  			    __attribute__((format(printf, 2, 3)));
> +extern int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
> +				  va_list vargs);
>  
>  static inline const char *kobject_name(const struct kobject *kobj)
>  {
> diff --git a/lib/kobject.c b/lib/kobject.c
> index 0487d1f..a6dec32 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -212,7 +212,7 @@ static int kobject_add_internal(struct kobject *kobj)
>   * @fmt: format string used to build the name
>   * @vargs: vargs to format the string.
>   */
> -static int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
> +int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
>  				  va_list vargs)
>  {
>  	const char *old_name = kobj->name;
> 

I cut this part out of this patch, as it's not needed here, and applied
the rest.

thanks,

greg k-h
