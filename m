Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbZHVOiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbZHVOiy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 10:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbZHVOix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 10:38:53 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42308 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbZHVOiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 10:38:52 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A9002D6.3070301@s5r6.in-berlin.de>
Date: Sat, 22 Aug 2009 16:38:14 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090630 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@verizon.net>
CC: Robert Hancock <hancockrwd@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Regression: Linux 2.6.31-rc7 lost sensors on asus mobo
References: <alpine.LFD.2.01.0908211810390.3158@localhost.localdomain> <4A8F8C49.2030406@gmail.com> <4A8FCE50.9070801@s5r6.in-berlin.de> <200908220948.03426.gene.heskett@verizon.net>
In-Reply-To: <200908220948.03426.gene.heskett@verizon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> I have applied that fix from the bz entry to my grub.conf but have not 
> rebooted as yet.  However if this asus_atk0110.ko module is supposed to do 
> the same job, then obviously I do not have some other, required option set in 
> my .config's for rc6 and rc7.  Directly choosing it doesn't seem to be 
> available in a make xconfig.  What am I missing?

The entry is in 'Device Drivers'/ 'Hardware Monitoring support'/ 'ASUS 
ATK0110 ACPI hwmon (SENSORS_ATK0110)' and depends on:  HWMON (Hardware 
Monitoring support), X86, ACPI, EXPERIMENTAL.  ACPI in turn depends on 
PM (Power Management support).
-- 
Stefan Richter
-=====-==--= =--- =-==-
http://arcgraph.de/sr/
