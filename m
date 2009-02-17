Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbZBQWbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbZBQWbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 17:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbZBQWaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 17:30:55 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:43227 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078AbZBQWay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 17:30:54 -0500
X-Greylist: delayed 3551 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Feb 2009 17:30:52 EST
Message-ID: <499B3A8F.7070609@free.fr>
Date: Tue, 17 Feb 2009 23:30:39 +0100
From: =?ISO-8859-1?Q?Nicolas_de_Peslo=FCan?= <nicolas.2p.debian@free.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Jay Vosburgh <fubar@us.ibm.com>
CC: Brian Haley <brian.haley@hp.com>, "J.A. Magallon" <jamagallon@ono.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, netdev@vger.kernel.org,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       bonding-devel@lists.sourceforge.net
Subject: Re: [Bonding-devel] 2.6.29 regression? Bonding tied to IPV6 in	29-rc5
References: <alpine.LFD.2.00.0902131413120.3179@localhost.localdomain>	<20090217095232.5da06b9f@werewolf.home>	<200902172001.41804.arvidjaar@mail.ru>	<200902172117.22671.arvidjaar@mail.ru> <499B19AF.1000003@hp.com> <16929.1234904788@death.nxdomain.ibm.com>
In-Reply-To: <16929.1234904788@death.nxdomain.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jay Vosburgh wrote:
> 	I'm not sure either of those really helps.  Distro kernels are
> built with CONFIG_IPV6 (and would have the CONFIG_BONDING_IPV6_DINGUS
> enabled as well), so the common case users would have it enabled, too.
> 
> 	Putting the ipv6 bits into a different module might not help,
> either, because the "core" bonding code would still have the call to the
> ipv6 functions.  Unless there's some magic way to somehow know at
> runtime whether or not the ipv6 module is loaded, and only try to
> resolve those symbols if ipv6 is loaded.  That seems complicated.

What about aliasing ipv6 to a dummy module "dummy-ipv6-for-bonding" that 
only provide the required symbols and do (close to) nothing ?

Just my two cents.

     Nicolas.
