Return-Path: <linux-kernel-owner+w=401wt.eu-S1758471AbZBSUwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471AbZBSUwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 15:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbZBSUwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 15:52:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55882 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbZBSUwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 15:52:04 -0500
Message-ID: <499DC5A6.1080305@zytor.com>
Date: Thu, 19 Feb 2009 12:48:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, Petr Tesarik <ptesarik@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: remove unneeded endless loop in BUG()
References: <1235068713.15053.99.camel@nathan.suse.cz> <20090219185935.GA21820@elte.hu> <499DB8BA.3050708@zytor.com> <499DC545.2030402@goop.org>
In-Reply-To: <499DC545.2030402@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> There's no reason to expect an "asm volatile" to stay put; the 
> "volatile" has nothing to do with preventing code motion.  The only way 
> to make an asm stick in one place is with data dependencies, and I'm not 
> sure what the dependency for __builtin_trap might be.  I'm guessing its 
> a "memory" clobber, but that's pure guesswork.
> 

I looked through this with HJL; the bottom line is that although it 
probably would work, it's not worth it.

I submitted GCC bug 39252 to get __builtin_not_reached(); instead.

	-hpa
