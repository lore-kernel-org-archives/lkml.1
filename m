Return-Path: <linux-kernel-owner+w=401wt.eu-S1760105AbYBYWpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760105AbYBYWpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:45:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756967AbYBYWoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:44:55 -0500
Received: from mga05.intel.com ([192.55.52.89]:53562 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756750AbYBYWoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:44:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,403,1199692800"; 
   d="scan'208";a="524297240"
Message-ID: <47C344E5.5050205@linux.intel.com>
Date: Mon, 25 Feb 2008 14:44:53 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Gabriel C <nix.or.die@googlemail.com>
CC: Laurent Riffard <laurent.riffard@free.fr>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Stuart Bennett <sb476@cam.ac.uk>, Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc2-mm1: WARNING at arch/x86/mm/ioremap.c:129
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B7553D.5040601@free.fr> <47C0BDE2.4020402@googlemail.com> <47C0DB7D.70407@linux.intel.com> <47C2ED51.4000105@googlemail.com>
In-Reply-To: <47C2ED51.4000105@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Arjan van de Ven wrote:
>> Gabriel C wrote:
>>> Laurent Riffard wrote:
>>>> Le 16.02.2008 09:25, Andrew Morton a écrit :
>>>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/
>>> [..]
>>>
>>> I'm getting that in mainline now on one of my older laptops also.
>> we fixed the cause of the machine you quoted; so I suspect yours is different..
>> Can you get me your stacktrace ? Can you try the patch from this thread to show
>> what memory the offender tries to access ?
> 
> Arjan , sorry for the lag.
> 
> With your patch from http://marc.info/?l=linux-kernel&m=120336371506283&w=2 I don't have a warning anymore.
> 

that is ... odd since it's the same in theory, just with some added printk's ;-(
