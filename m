Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbZFVMfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbZFVMfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 08:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbZFVMfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 08:35:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:21672 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbZFVMfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 08:35:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,268,1243839600"; 
   d="scan'208";a="424248582"
Message-ID: <4A3F7A93.5080004@linux.intel.com>
Date: Mon, 22 Jun 2009 14:35:31 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.30-git(16 and 17) system hangs after resume from suspend
 to 	disk, mce related?
References: <8db1092f0906211002y2b391212ve2902fc3a6517586@mail.gmail.com>	 <4A3E7F38.7030300@linux.intel.com>	 <8db1092f0906211313x73ac9340n9af5775b56cfd189@mail.gmail.com>	 <4A3EE668.5090400@jp.fujitsu.com>	 <8db1092f0906220019x1560c26dsd5a6daa3ea612ec@mail.gmail.com>	 <4A3F55C7.4030909@linux.intel.com> <8db1092f0906220453k5595998er1400567cbcdf3e12@mail.gmail.com>
In-Reply-To: <8db1092f0906220453k5595998er1400567cbcdf3e12@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej Rutecki wrote:
> 2009/6/22 Andi Kleen <ak@linux.intel.com>:
> 
>> Too bad. Were you able to set up a console during the hang?
>>
>> e.g. if you have a second system could you perhaps configure netconsole
>> (See Documentation/networking/netconsole.txt) and capture the messages?
>>
> 
> I configure netconsole. But it doesn't show any messages when system hangs:

Was this with check_interval = 1 ?

Do you see something when you set it to 60 or so (you need to wait 60 seconds)?

-Andi
