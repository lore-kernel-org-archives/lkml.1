Return-Path: <linux-kernel-owner+w=401wt.eu-S1761743AbYEARt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761743AbYEARt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 13:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbYEARtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 13:49:18 -0400
Received: from main.gmane.org ([80.91.229.2]:35318 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbYEARtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 13:49:18 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Russ Dill <Russ.Dill@gmail.com>
Subject: Re: Slow DOWN, please!!!
Date: Thu, 1 May 2008 17:49:06 +0000 (UTC)
Message-ID: <loom.20080501T174627-71@post.gmane.org>
References: <20080429.190352.137408408.davem@davemloft.net>  <4817EF91.4080800@davidnewall.com>  <20080429.211835.130816277.davem@davemloft.net>  <48186E57.5070805@davidnewall.com>  <alpine.LFD.1.10.0804300739350.2997@woody.linux-foundation.org>  <4818B8A7.4000902@davidnewall.com>  <alpine.LFD.1.10.0804301127020.2980@woody.linux-foundation.org>  <4818C0BF.5020002@davidnewall.com>  <alpine.LFD.1.10.0804301202200.2980@woody.linux-foundation.org>  <4818C571.8040609@davidnewall.com>  <alpine.LFD.1.10.0804301223220.2980@woody.linux-foundation.org>  <481947AF.4090101@davidnewall.com> <1209655700.27499.28.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 70.190.167.62 (Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9b5) Gecko/2008041515 Firefox/3.0b5)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I Recently found a system with a 2.6.4 kernel, and when i upgraded to
> 2.6.23, i saw memory usage increase from ~250mb to around 500. I
> upgraded to .25 to see if it was some weird bug, but it is the same.
> 
> Unfortunately i cannot investigate more, as i only had the box for a
> very short time, but this is alot more concerning to me.
> 

Memory is not something that is difficult to track. Its likely one of two things:

a) Your card now has 3d support, hooray! and X is mapping more regions, which
isn't really additional RAM usage.

b) Linux is caching more things, hooray! I'm not saying that you are one of
those people who just looks at the free number and doesn't think any further,
but you might be.

or c, the kernel has another 250MB is kernel data structures, seems unlikely.


