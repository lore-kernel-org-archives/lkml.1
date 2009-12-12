Return-Path: <linux-kernel-owner+w=401wt.eu-S1762895AbZLLAZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762895AbZLLAZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 19:25:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762771AbZLLAZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 19:25:09 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:24035 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762758AbZLLAZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 19:25:08 -0500
Date: Fri, 11 Dec 2009 16:23:23 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, devel@driverdev.osuosl.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] STAGING patches for 2.6.33-git
Message-Id: <20091211162323.1ec395b6.randy.dunlap@oracle.com>
In-Reply-To: <20091211234017.GA11006@kroah.com>
References: <20091211212704.GC6624@kroah.com>
	<alpine.LFD.2.00.0912111527480.3526@localhost.localdomain>
	<20091211234017.GA11006@kroah.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B22E2DD.0144:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Dec 2009 15:40:17 -0800 Greg KH wrote:

> On Fri, Dec 11, 2009 at 03:29:09PM -0800, Linus Torvalds wrote:
> > 
> > 
> > On Fri, 11 Dec 2009, Greg KH wrote:
> > >
> > > Here is the big staging merge for the 2.6.33-git tree
> > 
> > "B.A.T.M.A.N. Advanced Meshing Protocol"?
> 
> I just take the patches, I don't pick the names :)
> 
> > Oh, and I think I found a bug in BATMAN already: if you say 'no' to him, 
> > he still asks whether you want to debug him. 
> > 
> > Please, Greg, teach BATMAN that "No means no!". 
> 
> Doh, I have a patch for that around here from Randy, it didn't make it
> in...  Hm, no, he didn't send the patch, just pointed it out.  Here it
> is below, or you can pull from the same tree and get it:
> 
> 	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/
> 

but one of the maintainers did you send a patch for this...


> thanks,
> 
> greg k-h
> 
> From: Greg Kroah-Hartman <gregkh@suse.de>
> Subject: [PATCH] Staging: batman: fix debug Kconfig option
> 
> The debug batman option needs to depend on the correct
> config option.
> 
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> diff --git a/drivers/staging/batman-adv/Kconfig b/drivers/staging/batman-adv/Kconfig
> index b9742e7..7632f57 100644
> --- a/drivers/staging/batman-adv/Kconfig
> +++ b/drivers/staging/batman-adv/Kconfig
> @@ -15,7 +15,7 @@ config BATMAN_ADV
>  
>  config BATMAN_DEBUG
>  	bool "B.A.T.M.A.N. debugging"
> -	depends on BATMAN != n
> +	depends on BATMAN_ADV != n
>  	help
>  
>  	  This is an option for use by developers; most people should
> _______________________________________________


---
~Randy
