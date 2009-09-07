Return-Path: <linux-kernel-owner+w=401wt.eu-S1751733AbZIGTNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733AbZIGTNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 15:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751025AbZIGTNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 15:13:54 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:58902 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbZIGTNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 15:13:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XALlWAQQpBCo/mZtHWVT8rcqkuiQuMtEoRJh39glSZNbz903ozzfCggTpqspelT46E
         86p478G8Kv6yRYFkl9BmaIlb8uDqQnmZ7pBH8o8BbwFM0RXShnDxufVmpZENsHfI0JgK
         S6VBJljzqvVqiPoxZz74Mfbw8JKMnSqXjLOhw=
Date: Mon, 7 Sep 2009 21:12:19 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ma Ling <ling.ma@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Zhao Yakui <yakui.zhao@intel.com>, Eric Anholt <eric@anholt.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bisected] Output to external monitor is broken (Re: Linux
	2.6.31-rc9)
Message-ID: <20090907191219.GA5015@Pilar.aei.mpg.de>
References: <alpine.LFD.2.01.0909051645430.3329@localhost.localdomain> <20090906142206.GA4449@Pilar.aei.mpg.de> <alpine.LFD.2.01.0909071125430.25628@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0909071125430.25628@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon  7.Sep'09 at 11:37:39 -0700, Linus Torvalds wrote:
>   Carlos - can you also do the full dmesg _with_ the corruption? I realize 
>   that your screen is unreadable, but if you can just log in blindly, and
>   do a "dmesg > saved-dmesg-file" and then do a clean reboot? No need for 
>   a serial console or anything fancy - I assume the machine is still 
>   working, just with bad output.
> 
>   It might also be a good idea to boot with "drm.debug=15" to enable much 
>   more debugging output.
> 			- Linus ]

I am no longer at the institute with the monitor to test, but I've already
uploaded similar debug info to the bugzilla upon ykzhao's request this
morning (but I think you were not Cc:-ed on that request, though).

http://bugzilla.kernel.org/show_bug.cgi?id=14139

PS: The external monitor is unreadable, but the laptop's screen is still good.
