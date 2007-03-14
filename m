Return-Path: <linux-kernel-owner+w=401wt.eu-S1751540AbXCNWH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbXCNWH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 18:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbXCNWH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 18:07:27 -0400
Received: from 1wt.eu ([62.212.114.60]:1180 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbXCNWH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 18:07:27 -0400
Date: Wed, 14 Mar 2007 23:07:02 +0100
From: Willy Tarreau <w@1wt.eu>
To: kostik@atnn.ru
Cc: linux-kernel@vger.kernel.org
Subject: Re: kswapd & 2.4.21-47.0.0.1
Message-ID: <20070314220701.GQ943@1wt.eu>
References: <45F7FA3B.6070303@atnn.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F7FA3B.6070303@atnn.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Mar 14, 2007 at 04:35:55PM +0300, Konstantin Kalin wrote:
> Hello, All
> 
> I have the following configuration: CentOS 3.8, kernel 
> 2.4.21-41.0.01.EL, Dialogic boards.
> Sometimes a kernel panic happens. I setup netdump and got several crash 
> dumps and logs. Backtrace shows that kswapd called BUG in try_to_unmap 
> function. Unfortunately I couldn't upgrade the kernel because of 
> proprietary Dialogic drivers which are precompiled.
> 
> Could somebody help me? I tried to find similar issues in maillist and 
> failed with it. There are a few messages but they describe another case.

Well, I think you're trying to get both the cake and the money for it.
You use a vendor-specific stable kernel in order to get a high reliability
and good hardware support, but without paying for the customer support
associated with it, and when you have a problem you ask for free help
here where people don't know much about it (except for those who worked
on it).

By trying to get all advantages, you're in the worst situation : you have
a bug with a kernel that nobody knows except the vendor, and you can't
beat the vendor for this. I don't know if CentOS offers community-based
support through mailing lists or such, but maybe you'd loose less time
and money by buying the smallest support contract from RH and ask them
to help you on this problem.

> As I understand the rmap.c are under active development and it's 
> strongly been changing per each kernel version. Also if I understand 
> correct rmap.c has appeared in the kernel 2.6.x and my version of the 
> kernel is a backport by RedHat from 2.6 to 2.4.

Nope, it was initially written for 2.4 by Rik van Riel, and supported
for a long time as a patch for these kernels. Later it got merged in
2.4-ac which became a base for RHEL3. It was also merged in 2.6 but
I believe that it got important changes, though I'm not sure.

> Information about the crash is below. The specific of my system is a lot 
> of java thread (up to 1500).

I'm not sure that many people here will be able to provide you with much
help, unfortunately.

Regards,
Willy

