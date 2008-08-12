Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbYHLNsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbYHLNsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 09:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbYHLNsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 09:48:20 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:6470 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbYHLNsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 09:48:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=R0xXmfapm6Dzbj1LYFqdYWdUo71df/KLcnIoaU8rJdhoohyU9CX2EVqWgcoP28u6GE
         cB1iqQ9LugtNe+9otYYjeg+/NzYUwLZlt6Abj7QPY1a3sN56GzXtUIq9R7Z9lWrOtgJb
         48AfxHAzRejnIMzrH3/aCcWa4IBsLMAcPbSUI=
Message-ID: <b9df5fa10808120648x5bd541cdpd020cee836e89f20@mail.gmail.com>
Date: Tue, 12 Aug 2008 19:48:17 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling (take 4)
In-Reply-To: <b9df5fa10808120501i57dbd71k71b54cca0bfb2ff2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218490433-10576-1-git-send-email-maxk@qualcomm.com>
	 <48A0B16B.2080801@qualcomm.com>
	 <b9df5fa10808112021v7bb48c9ejefab284bea82c837@mail.gmail.com>
	 <48A1032F.4040606@qualcomm.com>
	 <b9df5fa10808120501i57dbd71k71b54cca0bfb2ff2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/12/08, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> On 8/12/08, Max Krasnyansky <maxk@qualcomm.com> wrote:
>
> > Rakib Mullick wrote:
>  >  > One more thing Max, while you are allocating memory for "dattr"  I
>  >  > think it  needs to check that it is successful or not . I've shown it
>  >  > on one of my previous patch on 7th Aug.
>  >
>  >
>  > I think you missed this part of the patch
>  >
>  >
>  >  > +     /*
>  >  > +      * The rest of the code, including the scheduler, can deal with
>  >  > +      * dattr==NULL case. No need to abort if alloc fails.
>  >  > +      */
>  >  >       dattr = kmalloc(ndoms * sizeof(struct sched_domain_attr), GFP_KERNEL);
>  >
>  >
>  > I replied to your patch saying that we do not need to check it. And Paul
>  >  suggested to add a comment to explain why.
>
Ok, this is the second place. But, what about the first place ( I
 mean in line 614).
>  >
>  >
>  >  Max
>  >
>  >
>  >
>
