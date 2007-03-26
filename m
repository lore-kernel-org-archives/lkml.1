Return-Path: <linux-kernel-owner+w=401wt.eu-S933640AbXCZWhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640AbXCZWhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 18:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933648AbXCZWhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 18:37:00 -0400
Received: from smtp111.sbc.mail.mud.yahoo.com ([68.142.198.210]:47957 "HELO
	smtp111.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933640AbXCZWg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 18:36:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mxdHZOaXqWM6R8kMIhHRBMHshKUAYtKbDCuzCUXpc8XiZPPuo7kIUoqwU56zhR6p8+Hw6fjDFBPSSLE9lg/z8dlMmtuYotqt1YLBhUJZLzTDB74uWxLsfVMD0kb5KiOe6T9qzlMkn7xJv5AL5iKz9AO/AtN5yFvD3DFimFAFdWM=  ;
X-YMail-OSG: cDl374cVM1nIjo1by2jJgs_YmUgI92GHNja38Nz245wTLbXdo6gKovJ8pUjP_zllI1FWMKQQQV0hpCqnXBeqtAYhSGos6uYTdF1ZFHN0uAEb0M_Sc._MjNFtbc1EgPX6RVm_xwRdRKbKPlA-
From: David Brownell <david-b@pacbell.net>
To: bryan.wu@analog.com
Subject: Re: [PATCH -mm] Blackfin: spi driver cleanup and coding style fixing
Date: Mon, 26 Mar 2007 15:36:56 -0700
User-Agent: KMail/1.7.1
Cc: dbrownell@users.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <1174904080.32691.77.camel@roc-desktop>
In-Reply-To: <1174904080.32691.77.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703261536.56689.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 March 2007 3:14 am, Wu, Bryan wrote:
> Hi folks,
> 
> This patch cleanup blackfin SPI driver code and fix some coding style
> problems.

Good, thanks.  I'll forward the current state of my review, after
I cross-check it against these two patches.

That'll mean I need to re-start that review ... at that point it'd
be better to start with a single clean patch.


> -#ifdef DEBUG
> -#define ASSERT(expr) \
> -	if (!(expr)) { \
> -		printk(KERN_DEBUG "assertion failed! %s[%d]: %s\n", \
> -		       __FUNCTION__, __LINE__, #expr); \
> -		panic(KERN_DEBUG "%s", __FUNCTION__); \
> -	}
> -#else
> -#define ASSERT(expr)
> -#endif

Yes, that was certainly in the "remove that" category.

- Dave
