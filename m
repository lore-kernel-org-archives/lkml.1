Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbYBXC71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbYBXC71 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 21:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbYBXC7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 21:59:13 -0500
Received: from mga07.intel.com ([143.182.124.22]:24669 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750892AbYBXC7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 21:59:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,396,1199692800"; 
   d="scan'208";a="382783643"
Message-ID: <47C0DB7D.70407@linux.intel.com>
Date: Sat, 23 Feb 2008 18:50:37 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Gabriel C <nix.or.die@googlemail.com>
CC: Laurent Riffard <laurent.riffard@free.fr>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Stuart Bennett <sb476@cam.ac.uk>, Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc2-mm1: WARNING at arch/x86/mm/ioremap.c:129
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B7553D.5040601@free.fr> <47C0BDE2.4020402@googlemail.com>
In-Reply-To: <47C0BDE2.4020402@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Laurent Riffard wrote:
>> Le 16.02.2008 09:25, Andrew Morton a écrit :
>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/

>>
> [..]
> 
> I'm getting that in mainline now on one of my older laptops also.

we fixed the cause of the machine you quoted; so I suspect yours is different..
Can you get me your stacktrace ? Can you try the patch from this thread to show
what memory the offender tries to access ?
