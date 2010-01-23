Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140Ab0AWBG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab0AWBG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 20:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927Ab0AWBG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 20:06:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60344 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab0AWBG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 20:06:57 -0500
Message-ID: <4B5A4B44.3010002@zytor.com>
Date: Fri, 22 Jan 2010 17:05:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>,
       Yinghai Lu <yinghai@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       mingo@elte.hu, a.p.zijlstra@chello.nl, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RFC: deprecate CONFIG_X86_CPU_DEBUG and schedule it for rapid
 removal
References: <4B4E1633.8010700@pardus.org.tr>	<201001162312.34189.rjw@sisk.pl>	<4B52D6E2.8000904@pardus.org.tr>	<201001171444.14551.rjw@sisk.pl>	<4B53B8DD.9000809@zytor.com> <20100122165356.55cf88aa.akpm@linux-foundation.org>
In-Reply-To: <20100122165356.55cf88aa.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2010 04:53 PM, Andrew Morton wrote:
> 
> Would it not be better to fix that problem (perhaps just with the
> revert) so that 2.6.33, 2.6.32.x and earlier can be fixed?  Then we can
> nuke the feature in 2.6.34.
> 
> Alternatively, we can nuke the feature from 2.6.33 and 2.6.32.x and
> earlier right now.  Where "nuke" might mean "make it difficult to
> enable".
> 
> Whatever.  Bottom line is that it'd be nice to do something to fix up
> 2.6.33 and earlier.
> 

I would be all for nuking the feature immediately.  The easiest way to
nuke the feature quickly is to make it a noninteractive Kconfig feature.

All in favor?

	-hpa
