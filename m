Return-Path: <linux-kernel-owner+w=401wt.eu-S1760077AbXEVUYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077AbXEVUYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 16:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756261AbXEVUX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 16:23:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:50293 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936AbXEVUX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 16:23:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ozshkrTCai4xRUZQRhFZjbfqK2RP8X7CRQbHKNwh4oJDLIJz0q6uBT9UpVhYs5Vr82N+qo11owE4+mml+uK9K/F2f1F8HxXuby+r3uTU0Q+e3gL1HCpedQ31gAcS3n1E3mSXFvWl5GCN720fmKm7WI+ImmqZLXBXF3/CJNGTkp0=
Message-ID: <6bffcb0e0705221323r75c54997s1d34890dbb1c67f4@mail.gmail.com>
Date: Tue, 22 May 2007 22:23:56 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [BUG] local_softirq_pending storm
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Anant Nitya" <kernel@prachanda.info>, linux-kernel@vger.kernel.org
In-Reply-To: <20070522201046.GA6113@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705091942.22920.kernel@prachanda.hub>
	 <200705191525.28400.kernel@prachanda.hub>
	 <1179601868.12981.127.camel@chaos>
	 <200705200253.44992.kernel@prachanda.hub>
	 <1179697388.6570.26.camel@chaos>
	 <6bffcb0e0705221203s1ba21ed3j641e91036859db7d@mail.gmail.com>
	 <20070522201046.GA6113@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/05/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
>
> > Bad news - I hit a bug in 2.6.22-rc2-hrt3. Bug symptoms:
> > - X hangs (keyboard, mouse, sound etc.)
> > - only Magic SysRq works
>
> please try the patch below! I think we have nailed this bug.

I picked it from -hrt5 and so far so good.

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
