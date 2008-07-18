Return-Path: <linux-kernel-owner+w=401wt.eu-S1759176AbYGRT7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176AbYGRT7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 15:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbYGRT7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 15:59:45 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:54833 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041AbYGRT7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 15:59:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=pOKtAsgTKq8ujSUS7IdsgA99m/Ol7HZ6ly+N4nzwMAb7fLpPmT0seSLKXhDslUA94I
         pI0gvSNpkmbiiTCQjI93kOwClRLfNujuW3PwFRpgnllp/e2hQqFtfWwLn5N7cCn1APgE
         rjiRIK0jpAfCpKIDwNMIXCtG2PfppLIDvOyZ0=
Message-ID: <e9e943910807181259w5342fd1dj3e5043400efea68e@mail.gmail.com>
Date: Fri, 18 Jul 2008 20:59:42 +0100
From: "Duane Griffin" <duaneg@dghda.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: latest -git: A peculiar case of a stuck process (ext3/sched-related?)
Cc: linux-ext4@vger.kernel.org, sct@redhat.com, akpm@linux-foundation.org,
       adilger@sun.com, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <19f34abd0807181005m19f1770bka9d8bbac7a500d1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807180245l2a633644n1a8d91cb3587d9e4@mail.gmail.com>
	 <19f34abd0807180317g40a218a2p2bb2857c6f5aa659@mail.gmail.com>
	 <e9e943910807180600t1e65a9b8o7f85e2751368275d@mail.gmail.com>
	 <19f34abd0807181005m19f1770bka9d8bbac7a500d1@mail.gmail.com>
X-Google-Sender-Auth: 927424c50667e806
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/18 Vegard Nossum <vegard.nossum@gmail.com>:
> (This patch looks much shorter than the one I found for ext2, though,
> i.e. commit aa4f3f285643956bb614cf7b8f88e15f3a375886 from the
> historical git repository. Does it fix all the right cases? I don't
> mean to troll -- I just wanted to be sure you knew about it.)

Ah, the historical git archive, that explains why I couldn't find it!
Please, don't worry about being seen as trolling, I didn't know about
that commit and I appreciate the heads-up and your attention to this
in general.

I've just taken a look at it and where I could find the corresponding
ext3 code it all looked OK. The only change the commit makes that I
couldn't verify was to ext2_add_link, as I couldn't immediately spot
where the corresponding ext3 functionality is.

Having said that, as I mentioned in the comment to that patch, there
may well be similar problems still lurking. I tried to fix up all the
dodgy looking cases at first, but I screwed up and just introduced
more problems. After that it seemed safer to do a minimal fix and to
address other similar issues as and when we got test-cases for them.
With the sterling efforts of yourself and Sami we'll hopefully get
them sooner or later.

> I'll try it and report back if there's any trouble. Thanks,

Thanks!

> Vegard

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
