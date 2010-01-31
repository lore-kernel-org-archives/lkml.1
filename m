Return-Path: <linux-kernel-owner+w=401wt.eu-S1751409Ab0AaGF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab0AaGF7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 01:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236Ab0AaGF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 01:05:58 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:57198 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab0AaGF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 01:05:58 -0500
Date: Sat, 30 Jan 2010 22:05:26 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Jean Delvare <khali@linux-fr.org>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>, Stelian Pop <stelian@popies.net>,
       Michael Hanselmann <linux-kernel@hansmi.ch>
Subject: Re: i2c_powermac: Kernel access of bad area
In-Reply-To: <alpine.DEB.2.01.1001292202150.3483@bogon.housecafe.de>
Message-ID: <alpine.DEB.2.01.1001302156380.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.0912281934170.3483@bogon.housecafe.de> <1262079255.2173.216.camel@pasglop> <20100106173745.57207520@hyperion.delvare> <alpine.DEB.2.01.1001061913310.3483@bogon.housecafe.de> <20100107171738.2c83b13e@hyperion.delvare>
 <20100129091857.3b7228db@hyperion.delvare> <alpine.DEB.2.01.1001292202150.3483@bogon.housecafe.de>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1+eGf57SJeTc3qzZuINYnDd1xHjg20tx+yZhMT
 PP0m2rBNXuigolKpf0CGNFWJBTbe6Ut37eMhPrsfmElUjSbFyw
 FrAy9Ni/lGaxcRz1I5G5w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jan 2010 at 22:03, Christian Kujau wrote:
> On Fri, 29 Jan 2010 at 09:18, Jean Delvare wrote:
> > Christian, did you ever test this second patch of mine? If you did,
> > what was the outcome?

OK, I've now applied both the drivers/hwmon/ams/ patches and your earlier 
one for drivers/macintosh/therm_adt746x.c [0] to a current -git checkout 
and now I can unload i2c_powermac, list and read the remaining files in
/sys/devices/temperatures, load i2c_powermac again, and unload, and
load, and ... - it's wonderful! :-) No oopses so far.

Feel free to add a Tested-by: Christian Kujau <lists@nerdbynature.de>
so that the patches can be pushed into mainline.

Thanks for the fixes, Jean!

Christian.

[0] http://nerdbynature.de/bits/2.6.33-rc2/i2c_powermac/r2/
-- 
BOFH excuse #337:

the butane lighter causes the pincushioning
