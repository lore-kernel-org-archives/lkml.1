Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbZA1ANj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbZA1ANj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 19:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbZA1ANa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 19:13:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46337 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbZA1AN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 19:13:29 -0500
Message-ID: <497FA2F5.2040806@zytor.com>
Date: Tue, 27 Jan 2009 16:12:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [mingo@elte.hu: [git pull] headers_check fixes]
References: <20090127222825.GA27097@elte.hu> <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain> <497F9740.4000505@zytor.com> <alpine.LFD.2.00.0901271527340.3123@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0901271527340.3123@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> Do you think the "fix headers_check" patches spend lots of time analyzing 
> things? I bet no. They just try to make the warning go away, so you don't 
> actually end up with any more "coverage" anyway. Quite the reverse - 
> instead of having a simple rule ("CONFIG_xyz options simply do not exist 
> in user space"), you end up having ad-hoc hacks on a per-fix basis.
> 

This is probably true.  I think we should add this as one more of the 
preprocessing rules which we really should just do, as well as automatic 
mangling of integer types.

	-hpa

