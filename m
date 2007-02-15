Return-Path: <linux-kernel-owner+w=401wt.eu-S1161204AbXBOUfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161204AbXBOUfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 15:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161210AbXBOUfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 15:35:43 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49981 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161193AbXBOUfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 15:35:22 -0500
Date: Thu, 15 Feb 2007 14:35:17 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: menage@google.com
Cc: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, vatsa@in.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, devel@openvz.org
Subject: Re: [PATCH 2/7] containers (V7): Cpusets hooked into containers
Message-ID: <20070215203517.GA30344@sergelap.austin.ibm.com>
References: <20070212081521.808338000@menage.corp.google.com> <20070212085104.290909000@menage.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070212085104.290909000@menage.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting menage@google.com (menage@google.com):
> Index: container-2.6.20/init/Kconfig
> ===================================================================
> --- container-2.6.20.orig/init/Kconfig
> +++ container-2.6.20/init/Kconfig
> @@ -239,17 +239,12 @@ config IKCONFIG_PROC
>  	  through /proc/config.gz.
> 
>  config CONTAINERS
> -	bool "Container support"
> -	help
> -	  This option will let you create and manage process containers,
> -	  which can be used to aggregate multiple processes, e.g. for
> -	  the purposes of resource tracking.
> -
> -	  Say N if unsure
> +	bool

Hi,

why did you do this?

thanks,
-serge
