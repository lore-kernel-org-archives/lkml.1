Return-Path: <linux-kernel-owner+w=401wt.eu-S934667AbZDIPaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934667AbZDIPaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935232AbZDIP3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:29:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45855 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935008AbZDIP3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:29:19 -0400
Date: Thu, 9 Apr 2009 08:26:40 -0700
From: Greg KH <gregkh@suse.de>
To: Subrata Modak <subrata@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       linux-next <linux-next@vger.kernel.org>
Subject: Re: [BUILD FAILURE 03] Next April 9 : x86_64 randconfig
	[drivers/staging/go7007/go7007-driver.c]
Message-ID: <20090409152640.GB4475@suse.de>
References: <1239272681.5188.37.camel@subratamodak.linux.ibm.com> <1239286279.5188.74.camel@subratamodak.linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1239286279.5188.74.camel@subratamodak.linux.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 07:41:19PM +0530, Subrata Modak wrote:
> Observed the following build error:
> 
> CC drivers/staging/go7007/go7007-driver.o
> drivers/staging/go7007/go7007-driver.c: In function
> ‘go7007_register_encoder’:
> drivers/staging/go7007/go7007-driver.c:284: error: ‘TUNER_SET_TYPE’
> undeclared (first use in this function)
> drivers/staging/go7007/go7007-driver.c:284: error: (Each undeclared
> identifier is reported only once
> drivers/staging/go7007/go7007-driver.c:284: error: for each function it
> appears in.)
> make[3]: *** [drivers/staging/go7007/go7007-driver.o] Error 1
> make[2]: *** [drivers/staging/go7007] Error 2
> make[1]: *** [drivers/staging] Error 2
> make: *** [drivers] Error 2

Thanks, I see this here now with the 2.6.30-rc1 release.  It was due to
some v4l api changes, I'll fix it up.

thanks,

greg k-h
