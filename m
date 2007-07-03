Return-Path: <linux-kernel-owner+w=401wt.eu-S1759171AbXGCJMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171AbXGCJMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 05:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991AbXGCJL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 05:11:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:60491 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbXGCJL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 05:11:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rymJvAoKf60T2b91m0Wg5lHwltjsOGMYZvS3eVcqxBWFwZQQP6FtdEhZIpETYo4dWumPnkuBKp3kBdcU/IypdSuJJnle+GELZeBu8cHoy6yOyBgOQD84NSObncDVGGcVRDJsVzRMCbo8Zt4ZILmrMWtrmPxUdqRaCcFA4Yo/Bp4=
Message-ID: <19f34abd0707030211r10f7ba04l6b749be5db4b7302@mail.gmail.com>
Date: Tue, 3 Jul 2007 11:11:56 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v18
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070703071512.GA29984@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070622220202.GA16872@elte.hu>
	 <19f34abd0707020444r47221944tf7f33b2a0d17c367@mail.gmail.com>
	 <20070703071512.GA29984@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/3/07, Ingo Molnar <mingo@elte.hu> wrote:
> does it still get more CPU time than you'd expect it to get? A reniced
> or SCHED_IDLE task will 'fill in' any idle time that it senses, so in
> itself it's not an anomaly if a task gets 50% and FEH fills in the
> remaining 50%. Does it still get CPU time if you start two CPU hogs:
>
>    for (( N=0; N < 2; N++ )); do ( while :; do :; done ) & done
>
> ? If yes, that would be an anomaly.

No, with this test, it gets the expected amount of CPU. Thanks for
clearing it up!

Vegard
