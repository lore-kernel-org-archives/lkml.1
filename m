Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253Ab0AERUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab0AERUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 12:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175Ab0AERUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 12:20:52 -0500
Received: from mail176c2.megamailservers.com ([69.49.111.76]:35204 "EHLO
	mail176c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755236Ab0AERUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 12:20:51 -0500
X-Greylist: delayed 2145 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jan 2010 12:20:51 EST
X-Authenticated-User: kristoffer.gaisler.com
Message-ID: <4B436BC9.5020102@gaisler.com>
Date: Tue, 05 Jan 2010 17:41:45 +0100
From: Kristoffer Glembo <kristoffer@gaisler.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070601 SeaMonkey/1.1.2
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: [RFC][PATCH 14/14] Convert sparc to read/update_persistent_clock
References: <1261540762.3508.61.camel@localhost.localdomain>	 <1261540826.3508.62.camel@localhost.localdomain>	 <1261540902.3508.63.camel@localhost.localdomain>	 <1261540988.3508.64.camel@localhost.localdomain>	 <1261541054.3508.65.camel@localhost.localdomain>	 <1261541130.3508.66.camel@localhost.localdomain>	 <1261541188.3508.67.camel@localhost.localdomain>	 <1261541286.3508.69.camel@localhost.localdomain>	 <1261541342.3508.70.camel@localhost.localdomain>	 <1261541415.3508.71.camel@localhost.localdomain>	 <1261541491.3508.72.camel@localhost.localdomain>	 <1261541567.3508.73.camel@localhost.localdomain>	 <1261541643.3508.74.camel@localhost.localdomain>	 <1261541703.3508.75.camel@localhost.localdomain> <1261541771.3508.76.camel@localhost.localdomain>
In-Reply-To: <1261541771.3508.76.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

john stultz wrote:
> This patch converts the sparc architecture to use the generic
> read_persistent_clock and update_persistent_clock interfaces, reducing
> the amount of arch specific code we have to maintain, and allowing for
> further cleanups in the future.
>
> I have not built or tested this patch, so help from arch maintainers
> would be appreciated.
>
>   
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
>   

The sparc32 patch does not build because you forgot to remove the
last_rtc_update variable declaration:

arch/sparc/kernel/time_32.c: In function 'timer_interrupt':
arch/sparc/kernel/time_32.c:94: warning: unused variable 'last_rtc_update'

Best regards,
Kristoffer Glembo

