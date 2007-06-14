Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbXFNHGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbXFNHGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 03:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbXFNHG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 03:06:28 -0400
Received: from terminus.zytor.com ([192.83.249.54]:60001 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbXFNHG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 03:06:27 -0400
Message-ID: <4670E8BF.8000202@zytor.com>
Date: Thu, 14 Jun 2007 00:05:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Joe Perches <joe@perches.com>, holzheu@linux.vnet.ibm.com,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, akpm@osdl.org, mtk-manpages@gmx.net,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: [RFC/PATCH] Documentation of kernel messages
References: <1181747217.29512.9.camel@localhost.localdomain> <20070613175147.GB14355@suse.de> <1181758680.26375.25.camel@localhost.localdomain>            <1181761496.6020.158.camel@localhost> <7344.1181789698@turing-police.cc.vt.edu>
In-Reply-To: <7344.1181789698@turing-police.cc.vt.edu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Wed, 13 Jun 2007 12:04:56 PDT, Joe Perches said:
> 
>> I believe it better to simply add __FILE__ & __LINE__ to the
>> macro rather than some other externally specified unique
>> identifier that adds developer overhead and easily gets stale.
> 
> There's been plenty of times I've wished for that.  Now if we just found a way
> to do something sane for drivers/net/wireless/mac80211/iwlwifi/base.c ;)
> 

Why don't you just redefine the KERN_* macros which is used by almost
every printk in the system to contain said __FILE__ and __LINE__, then?

	-hpa
