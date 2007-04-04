Return-Path: <linux-kernel-owner+w=401wt.eu-S2993004AbXDDTb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993004AbXDDTb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 15:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993039AbXDDTb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 15:31:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:3455 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993004AbXDDTb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 15:31:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,372,1170662400"; 
   d="scan'208"; a="224809993:sNHT19381068"
Message-ID: <4613FD2C.101@intel.com>
Date: Wed, 04 Apr 2007 12:31:56 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.10 (X11/20070311)
MIME-Version: 1.0
To: "Jeff V. Merkey" <jmerkey@wolfmountaingroup.com>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Latest e1000 7.3.20 driver busted with 2.6.20.4
References: <4613E230.6080608@wolfmountaingroup.com>
In-Reply-To: <4613E230.6080608@wolfmountaingroup.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff V. Merkey wrote:
> CC [M]  drivers/net/chelsio/mv88x201x.o
>   CC [M]  drivers/net/chelsio/my3126.o
>   LD [M]  drivers/net/chelsio/cxgb.o
>   CC      drivers/net/e1000/e1000_main.o
> drivers/net/e1000/e1000_main.c:1185:45: error: macro "INIT_WORK" passed 
> 3 arguments, but takes just 2
> ared (first use in this function)
> drivers/net/e1000/e1000_main.c:1184: error: (Each undeclared identifier 
> is reported only once
> drivers/net/e1000/e1000_main.c:1184: error: for each function it appears 
> in.)
> make[3]: *** [drivers/net/e1000/e1000_main.o] Error 1
> make[2]: *** [drivers/net/e1000] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2

this is hardly a thread for lkml as you're posting about out out-of-tree driver. 
  This issue has also been fixed in 7.4.35 which was released last week on 
e1000.sf.net. In the future, please post this stuff to 
e1000-devel@lists.sourceforge.net where we discuss the out-of-tree driver.

Cheers,

Auke
