Return-Path: <linux-kernel-owner+w=401wt.eu-S1759187AbXGBNnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187AbXGBNnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 09:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbXGBNnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 09:43:11 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:10108 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbXGBNnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 09:43:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YIfs8dFBeMdiN9eHCXF2PJukHWjwBU+mXGpFkDC8rI0L+Bnm1bPdqc+GBq4YScoVrrX7kcsa9NjfGKKPb3MVRPLSlRCerCKp0oRNXakJJy/R2pM2PamvgiNPPr3ptSe7vGzMVp+5IdE5hrTy2OBWe9XAeR6pX5j82aaKoSH6COU=
Message-ID: <19f34abd0707020643g6a274db5q1d25cabd85b9a25f@mail.gmail.com>
Date: Mon, 2 Jul 2007 15:43:09 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Subject: Re: [patch] CFS scheduler, -v18
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <b647ffbd0707020601r774a38d4gb62b6c07f1b5db32@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070622220202.GA16872@elte.hu>
	 <19f34abd0707020444r47221944tf7f33b2a0d17c367@mail.gmail.com>
	 <b647ffbd0707020601r774a38d4gb62b6c07f1b5db32@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/2/07, Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
> On 02/07/07, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > I have been running cfs-v18 for a couple of days now, and today I
> > stumbled upon a rather strange problem. Consider the following short
> > program:
> >
> > while(1)
> >         printf("%ld\r", 1000 * clock() / CLOCKS_PER_SEC);
>
> Is it running with a default (0) nice value?

Yes.

> could you please run the following script when your application is running?
> As you have pointed out :
>
> "... In fact, it seems that the longer it runs, the longer it takes to
> terminate (towards 5 seconds after running for a couple of minutes
> ..." ,

(I don't think it'll ever take more than 5 seconds, though.)

> please run the script a few times : say, before starting up your
> application, 10 sec. after it's got started, 1 minute, a few minute...
>
> http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

Resulting files at
http://vegard.afraid.org:1104/pub/cfs/

cfs-debug-info-2007.07.02-15:18:13    Before running program
cfs-debug-info-2007.07.02-15:19:51    ~10 secs after start
cfs-debug-info-2007.07.02-15:20:54    ~1 minute after start
cfs-debug-info-2007.07.02-15:25:52    ~5 minutes after start
cfs-debug-info-2007.07.02-15:30:54    ~10 minutes after start

a.out is my program, FahCore_78 is the f@h client.

Hope this helps.

Vegard
