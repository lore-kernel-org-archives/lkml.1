Return-Path: <linux-kernel-owner+w=401wt.eu-S1752550AbZBZAd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbZBZAd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 19:33:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbZBZAdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 19:33:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36735 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbZBZAdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 19:33:50 -0500
Message-ID: <49A5E28F.5050209@zytor.com>
Date: Wed, 25 Feb 2009 16:30:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Sam Ravnborg <sam@ravnborg.org>, Kyle McMartin <kyle@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>, mingo@redhat.com,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [patch 0/7] Use strict kernel types to fix the world
References: <20090225235138.062045835@arndb.de> <49A5DC30.4080803@zytor.com> <200902260124.13641.arnd@arndb.de>
In-Reply-To: <200902260124.13641.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Thursday 26 February 2009, H. Peter Anvin wrote:
>>> I split out netfilter, DRM and MTD, because of both
>>> size and potentially controversial changes.
>> I take it this supercedes your previous monolithic patch?
> 
> Patch 1/7 supercedes my previous patch and is still as monolithic,
> except for the separate 6/7 hunk. I only split the integer type
> patches by subsystem, but I did these from scratch now.
> 
> Patch 7/7 is a new one, based on your input from the last time
> we discussed it.

6/7 we already had in -tip, apparently.

I'm really of two minds regarding the patches that replace pure data 
types (2/7-5/7).  Part of me thinks it would be better to do this via a 
script in make headers_install, but another part of me thinks that that 
is a recipe for missing includes.

However, if subsystem maintainers are sharing headers with other 
platforms, it's probably the only sane road to go.

	-hpa

