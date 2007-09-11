Return-Path: <linux-kernel-owner+w=401wt.eu-S1764459AbXIKTaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764459AbXIKTaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761753AbXIKT3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:29:52 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:37010 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761514AbXIKT3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 15:29:51 -0400
Message-ID: <46E6ECAA.30601@s5r6.in-berlin.de>
Date: Tue, 11 Sep 2007 21:29:46 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Ben Collins <ben.collins@ubuntu.com>
CC: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: regression: fireware causes oops during system
References: <20070911190043.GA1577@elf.ucw.cz> <1189537716.7620.192.camel@cunning>
In-Reply-To: <1189537716.7620.192.camel@cunning>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Collins wrote:
> On Tue, 2007-09-11 at 21:00 +0200, Pavel Machek wrote:
>> I noticed empty suspend stopped working around 2.6.23-rc4, and it is
>> still present in 2.6.23-rc6. To reproduce
>> 
>> swapoff -a 
>> echo disk > /sys/power/state
>> echo disk > /sys/power/state
>> 
>> Unsetting
>> 
>> CONFIG_IEEE1394=y
>> 
>> solves the problem.
> 
> Since this is easy to reproduce, can you bisect it down?

I will check in a minute what I pushed out after 2.6.23-rc1, may save
Pavel some time.
-- 
Stefan Richter
-=====-=-=== =--= -=-==
http://arcgraph.de/sr/
