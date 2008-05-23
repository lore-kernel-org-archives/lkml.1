Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbYEWEB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbYEWEB7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 00:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbYEWEBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 00:01:49 -0400
Received: from beauty.rexursive.com ([203.171.74.242]:44243 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbYEWEBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 00:01:48 -0400
Subject: Re: capget() overflows buffers.
From: Bojan Smojver <bojan@rexursive.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Dave Jones <davej@codemonkey.org.uk>, Andrew Morgan <morgan@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080523020638.GF30402@sequoia.sous-sol.org>
References: <20080522140402.GB2071@codemonkey.org.uk>
	 <20080522175744.GE4018@sequoia.sous-sol.org>
	 <20080522205341.GA30402@sequoia.sous-sol.org>
	 <1211505622.20341.6.camel@shrek.rexursive.com>
	 <20080523020638.GF30402@sequoia.sous-sol.org>
Content-Type: text/plain
Date: Fri, 23 May 2008 14:01:46 +1000
Message-Id: <1211515306.20341.19.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-22 at 19:06 -0700, Chris Wright wrote:

> 1) switch to using the libcap interface, arguably the best sol'n since
> you know longer have to directly care about the kernel interface.
> only drawback is the additional library dependency.

I'm thinking Squid folks may want to pick this up long term.

> 2) force head->version to the older version, something like:
> 
> #ifdef  _LINUX_CAPABILITY_VERSION_1
>   head->version = _LINUX_CAPABILITY_VERSION_1;
> #else
>   head->version = _LINUX_CAPABILITY_VERSION;
> #endif
> 
> this has the drawback of always using the older 32bit caps, probably
> fine here, since you're not using new caps.

Probably the best short term suggestion. I will post this in my original
bug report.

Thank you for your suggestions!

-- 
Bojan

