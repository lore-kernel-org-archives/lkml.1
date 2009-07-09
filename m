Return-Path: <linux-kernel-owner+w=401wt.eu-S1761643AbZGIP2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761643AbZGIP2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 11:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761262AbZGIP1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 11:27:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46491 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761065AbZGIP1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 11:27:46 -0400
Date: Thu, 9 Jul 2009 08:18:03 -0700
From: Greg KH <gregkh@suse.de>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: jmorris@namei.org, sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on
 sysfs files, directories, and symlinks.
Message-ID: <20090709151803.GB24302@suse.de>
References: <1247074106-23405-1-git-send-email-dpquigl@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247074106-23405-1-git-send-email-dpquigl@tycho.nsa.gov>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 01:28:26PM -0400, David P. Quigley wrote:
> --- a/fs/sysfs/sysfs.h
> +++ b/fs/sysfs/sysfs.h
> @@ -57,6 +57,7 @@ struct sysfs_dirent {
>  	ino_t			s_ino;
>  	umode_t			s_mode;
>  	struct iattr		*s_iattr;
> +	u32			s_secid;
>  };

Why not just make this a void * like all other security hooks, and then
you and SMACK can pick and choose what you want to embed here?

thanks,

greg k-h
