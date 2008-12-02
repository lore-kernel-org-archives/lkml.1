Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbYLBXut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbYLBXut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 18:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYLBXul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 18:50:41 -0500
Received: from mga05.intel.com ([192.55.52.89]:19192 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753185AbYLBXuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 18:50:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,704,1220252400"; 
   d="scan'208";a="410833008"
Message-ID: <4935C9CC.8070308@linux.intel.com>
Date: Tue, 02 Dec 2008 15:50:36 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       tytso@mit.edu
Subject: Re: mmotm 2008-12-01-19-41: early exception (page fault -- deref
 of 0x20)
References: <4935C03A.7030603@gmail.com>	 <20081202153336.7b765ec7.akpm@linux-foundation.org> <1228261328.3196.174.camel@calx>
In-Reply-To: <1228261328.3196.174.camel@calx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> 
> If we oops or warn while picking a timesource, we'll have lots of fun?
> 

we really only need to mix in the tsc; ktime_get() is just an arch friendly way to get that
I supposed (wrongly).

but yes we need to do a few things
1) seed on demand with a platform time source
2) have a way where arch init can just hand semi random data during the boot process to
    increase the randomness (even if it doesn't count as entropy)
I got pulled in some big project at work so I might not get to it this week, but if nobody beats
me to it I will get to it ;-(
