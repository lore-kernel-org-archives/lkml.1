Return-Path: <linux-kernel-owner+w=401wt.eu-S1763270AbXLMQYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763270AbXLMQYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:24:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762639AbXLMQY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:24:27 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46981 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759448AbXLMQY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:24:26 -0500
Date: Thu, 13 Dec 2007 08:22:28 -0800
From: Greg KH <greg@kroah.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Badari Pulavarty <pbadari@gmail.com>, rsa@us.ibm.com
Subject: Re: 2.6.24-rc5-mm1 kobject changes broken with hvcs driver on
	powerpc - regression
Message-ID: <20071213162228.GB7580@kroah.com>
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org> <47611EAF.4080806@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47611EAF.4080806@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 05:29:43PM +0530, Kamalesh Babulal wrote:
> Hi,
> 
> The kernel build fails with following error message
> 
> drivers/char/hvcs.c: In function 'hvcs_open':
> drivers/char/hvcs.c:1180: error: wrong type argument to unary exclamation mark
> make[2]: *** [drivers/char/hvcs.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> 
> This driver was broken in 2.6.24-rc4-mm1 either on powerpc, and the discussion
> has been going on at
> 
> http://lkml.org/lkml/2007/12/5/141
> http://lkml.org/lkml/2007/12/7/280

Sorry, it's still in my TODO queue that I can (hopefully) plow through
today now that the big -stable updates are out...

thanks,

greg k-h
