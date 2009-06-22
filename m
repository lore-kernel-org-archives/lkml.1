Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbZFVJ6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbZFVJ6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 05:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZFVJ6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 05:58:34 -0400
Received: from mga06.intel.com ([134.134.136.21]:17675 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750996AbZFVJ6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 05:58:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,267,1243839600"; 
   d="scan'208";a="526714928"
Message-ID: <4A3F55C7.4030909@linux.intel.com>
Date: Mon, 22 Jun 2009 11:58:31 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.30-git(16 and 17) system hangs after resume from suspend
 to 	disk, mce related?
References: <8db1092f0906211002y2b391212ve2902fc3a6517586@mail.gmail.com>	 <4A3E7F38.7030300@linux.intel.com>	 <8db1092f0906211313x73ac9340n9af5775b56cfd189@mail.gmail.com>	 <4A3EE668.5090400@jp.fujitsu.com> <8db1092f0906220019x1560c26dsd5a6daa3ea612ec@mail.gmail.com>
In-Reply-To: <8db1092f0906220019x1560c26dsd5a6daa3ea612ec@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Patch remove warning.

Ok.


> Tested-by Maciej Rutecki <maciej.rutecki@gmail.com>
> 
> _But_ still system hangs after resume and during s2disk (while use
> echo 0 > /sys/devices...)

Too bad. Were you able to set up a console during the hang?

e.g. if you have a second system could you perhaps configure netconsole
(See Documentation/networking/netconsole.txt) and capture the messages?

-Andi


