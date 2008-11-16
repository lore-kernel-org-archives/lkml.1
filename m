Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbYKPAaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbYKPAaL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 19:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbYKPA34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 19:29:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:28413 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbYKPA3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 19:29:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OzmAZnDWH4IiLh5CFPB+R7ay1KsSK8tVMtxfo36ptOhhQFan4lnmg4DZDdEbQ6iYYJ
         gIUZirWeH62a89lgvuBxbW7R0gFJNSulLaFlk8C8mrafkBDy8UqGiBM4lFvhhlZFL9AP
         MIxuk4XphDgIP/inByIfGrOvazo04xUjQprAw=
Date: Sun, 16 Nov 2008 03:33:27 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 2/2] Add dev.mem.restricted sysctl
Message-ID: <20081116003327.GA2405@x200.localdomain>
References: <1226793823-32360-1-git-send-email-bwalle@suse.de> <1226793823-32360-3-git-send-email-bwalle@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226793823-32360-3-git-send-email-bwalle@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 01:03:43AM +0100, Bernhard Walle wrote:
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -858,6 +858,7 @@ enum {
>  	DEV_MAC_HID=5,
>  	DEV_SCSI=6,
>  	DEV_IPMI=7,
> +	DEV_MEM=8,
>  };
>  
>  /* /proc/sys/dev/cdrom */
> @@ -875,6 +876,11 @@ enum {
>  	DEV_PARPORT_DEFAULT=-3
>  };
>  
> +/* /proc/sys/dev/mem */
> +enum {
> +    DEV_MEM_RESTRICTED=1,
> +};

No new binary sysctls please.
