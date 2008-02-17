Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbYBQWgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbYBQWgT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 17:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbYBQWgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 17:36:08 -0500
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:30310 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbYBQWgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 17:36:07 -0500
Date: Sun, 17 Feb 2008 17:36:04 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: rubisher <rubisher@scarlet.be>
Cc: "rubi.sher" <rubi.sher@scarlet.be>, kyle <kyle@mcmartin.ca>,
       clameter <clameter@sgi.com>, bunk <bunk@kernel.org>,
       kyle <kyle@parisc-linux.org>, matthew <matthew@wil.cx>,
       grundler <grundler@parisc-linux.org>,
       linux-parisc <linux-parisc@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: parisc compile error
Message-ID: <20080217223604.GA26901@phobos.i.cabal.ca>
References: <JW6GMA$1445536B7A545413BA0D6B6753D6901F@scarlet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <JW6GMA$1445536B7A545413BA0D6B6753D6901F@scarlet.be>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 01:42:10PM +0100, rubisher wrote:
>

Can I get your Signed-off-by for this, Joel? (I assume you are Joel :)

cheers, Kyle

>     - some lake of changes of kset to kobj:
> --- ./drivers/parisc/pdc_stable.c.Orig	2008-01-28 07:09:26.000000000 +0000
> +++ ./drivers/parisc/pdc_stable.c	2008-02-13 11:22:16.000000000 +0000
> @@ -829,7 +829,7 @@
>  				   struct kobj_attribute *attr,
>  				   const char *buf, size_t count)
>  {
> -	return pdcs_auto_write(kset, attr, buf, count, PF_AUTOBOOT);
> +	return pdcs_auto_write(kobj, attr, buf, count, PF_AUTOBOOT);
>  }
>  
>  /**
> @@ -845,7 +845,7 @@
>  				     struct kobj_attribute *attr,
>  				     const char *buf, size_t count)
>  {
> -	return pdcs_auto_write(kset, attr, buf, count, PF_AUTOSEARCH);
> +	return pdcs_auto_write(kobj, attr, buf, count, PF_AUTOSEARCH);
>  }
>  
>  /**
> @@ -1066,7 +1066,7 @@
>  	}
>  
>  	/* Don't forget the root entries */
> -	error = sysfs_create_group(stable_kobj, pdcs_attr_group);
> +	error = sysfs_create_group(stable_kobj, &pdcs_attr_group);
>  
>  	/* register the paths kset as a child of the stable kset */
>  	paths_kset = kset_create_and_add("paths", NULL, stable_kobj);
> === <> ===
> 
> And the kernel build, but I don't yet try to boot it...
> 
> Hth,
> r.
> ---
> Scarlet One, ADSL 6 Mbps + Telephone, from EUR 29,95...
> http://www.scarlet.be/
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-parisc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
