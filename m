Return-Path: <linux-kernel-owner+w=401wt.eu-S1763990AbYBPCxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763990AbYBPCxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 21:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756994AbYBPCxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 21:53:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43462 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635AbYBPCxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 21:53:11 -0500
Message-ID: <47B64FE9.3000304@zytor.com>
Date: Fri, 15 Feb 2008 18:52:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: linux-kernel@vger.kernel.org, miltonm@bga.com,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Remove the new perl dependency from build.
References: <200802152010.05505.rob@landley.net>
In-Reply-To: <200802152010.05505.rob@landley.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> 
> Removed the special case "canned" logic from the perl script (it always requires
> Math::bigint when it runs now).  Moved the list of canned values into
> kernel/Makefile.  (It's already a selection menu in kconfig, so you can't
> just feed arbitrary values into it anyway.  If you add a new value to kconfig,
> add it to kernel/Makefile as well and delete kernel/timeconst.h so the build
> recreates it.)
> 

The problem is that for at least one architecture, CONFIG_HZ is settable 
to arbitrary values, so you need a way to invoke the generic code if you 
don't have a pre-canned value available.

I have to admit to having very little interest in this kind of 
minimality exercises, which seem to have pretty much academic value only 
-- in reality, people cross-compile the kernel to go onto this kind of 
minimal boxes.

	-hpa
