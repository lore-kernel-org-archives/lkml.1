Return-Path: <linux-kernel-owner+w=401wt.eu-S1759104AbYEBBsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759104AbYEBBsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 21:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYEBBr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 21:47:57 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51200 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbYEBBr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 21:47:57 -0400
Subject: Re: Slow DOWN, please!!!
From: Kasper Sandberg <lkml@metanurb.dk>
To: Russ Dill <Russ.Dill@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <loom.20080501T174627-71@post.gmane.org>
References: <20080429.190352.137408408.davem@davemloft.net>
	 <4817EF91.4080800@davidnewall.com>
	 <20080429.211835.130816277.davem@davemloft.net>
	 <48186E57.5070805@davidnewall.com>
	 <alpine.LFD.1.10.0804300739350.2997@woody.linux-foundation.org>
	 <4818B8A7.4000902@davidnewall.com>
	 <alpine.LFD.1.10.0804301127020.2980@woody.linux-foundation.org>
	 <4818C0BF.5020002@davidnewall.com>
	 <alpine.LFD.1.10.0804301202200.2980@woody.linux-foundation.org>
	 <4818C571.8040609@davidnewall.com>
	 <alpine.LFD.1.10.0804301223220.2980@woody.linux-foundation.org>
	 <481947AF.4090101@davidnewall.com> <1209655700.27499.28.camel@localhost>
	 <loom.20080501T174627-71@post.gmane.org>
Content-Type: text/plain
Date: Fri, 02 May 2008 03:47:55 +0200
Message-Id: <1209692875.16523.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-01 at 17:49 +0000, Russ Dill wrote:
> > I Recently found a system with a 2.6.4 kernel, and when i upgraded to
> > 2.6.23, i saw memory usage increase from ~250mb to around 500. I
> > upgraded to .25 to see if it was some weird bug, but it is the same.
> > 
> > Unfortunately i cannot investigate more, as i only had the box for a
> > very short time, but this is alot more concerning to me.
> > 
> 
> Memory is not something that is difficult to track. Its likely one of two things:
> 
> a) Your card now has 3d support, hooray! and X is mapping more regions, which
> isn't really additional RAM usage.
no, that isnt it. im talking ram USAGE. :)
> 
> b) Linux is caching more things, hooray! I'm not saying that you are one of
> those people who just looks at the free number and doesn't think any further,
> but you might be.
Im afraid this theory also isnt the case, i know what the cache is, and
i also know how to subtract :)

> 
> or c, the kernel has another 250MB is kernel data structures, seems unlikely.
Well yes that seems somewhat big, however, the kernel was the ONLY
change.

i can also say that i have noticed this on my own workstation, however
thats not really an as valid case, as i have also upgraded userspace and
such over time, but it used to be that my box wouldnt use more than
~100mb to boot into X with kde open, and about ~300mb at browsing/mail
and such, but these days my workstation easily uses 1.5gb of ram for no
apparent reason..

something certainly is fishy around here, these days people just tend to
fix it by throwing 10 times more ram in than should really be necessary,
which i guess, is because the ram prices has dropped 10 times
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

