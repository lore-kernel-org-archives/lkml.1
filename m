Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbYHLD1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbYHLD1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 23:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbYHLD1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 23:27:45 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8131 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbYHLD1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 23:27:45 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5358"; a="5623722"
Message-ID: <48A1032F.4040606@qualcomm.com>
Date: Mon, 11 Aug 2008 20:27:43 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rakib Mullick <rakib.mullick@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling
 (take 4)
References: <1218490433-10576-1-git-send-email-maxk@qualcomm.com>	 <48A0B16B.2080801@qualcomm.com> <b9df5fa10808112021v7bb48c9ejefab284bea82c837@mail.gmail.com>
In-Reply-To: <b9df5fa10808112021v7bb48c9ejefab284bea82c837@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rakib Mullick wrote:
> One more thing Max, while you are allocating memory for "dattr"  I
> think it  needs to check that it is successful or not . I've shown it
> on one of my previous patch on 7th Aug.

I think you missed this part of the patch

> +     /*
> +      * The rest of the code, including the scheduler, can deal with
> +      * dattr==NULL case. No need to abort if alloc fails.
> +      */
>       dattr = kmalloc(ndoms * sizeof(struct sched_domain_attr), GFP_KERNEL);

I replied to your patch saying that we do not need to check it. And Paul
suggested to add a comment to explain why.

Max


