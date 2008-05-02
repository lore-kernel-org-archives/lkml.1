Return-Path: <linux-kernel-owner+w=401wt.eu-S934816AbYEBMVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934816AbYEBMVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 08:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756636AbYEBMV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 08:21:27 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:29844 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbYEBMV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 08:21:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hf3qaWIc7szDRz7isKXSjDGv3R0h+qrrVdavWwbIJb4M/6dldC2mMj2vFF0C4BRXQUDcHk/zMuFFjtWO9CgJgb20aZajEnnaAfN0zIIaIXUZxF4FMril0/Js0RITnJtWp1/p7xtRsBNxAoRM5xx1IkMmfC3h4BUOXDV/dDYtjbM=
Message-ID: <82e4877d0805020521t696cc4fbu6ffd182f84ae1a2e@mail.gmail.com>
Date: Fri, 2 May 2008 08:21:24 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Mike Galbraith" <efault@gmx.de>
Subject: Re: Horrendous Audio Stutter - current git
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, "Frans Pop" <elendil@planet.nl>
In-Reply-To: <1209730185.18055.21.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com>
	 <1209717278.13978.136.camel@twins>
	 <82e4877d0805020410u78c6f03fr8e8e53d5a19f6846@mail.gmail.com>
	 <1209730185.18055.21.camel@marge.simson.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2008 at 8:09 AM, Mike Galbraith <efault@gmx.de> wrote:
>  Hm.  I've stumbled across a regression that may be related.  Can you
>  please try the attached with group scheduling enabled in current git?

In file included from kernel/sched.c:1902:
kernel/sched_fair.c: In function 'print_cfs_rq_tasks':
kernel/sched_fair.c:1602: error: implicit declaration of function
'calc_delta_weight'
kernel/sched_fair.c:1603: warning: format '%lu' expects type 'long
unsigned int', but argument 5 has type 'int'
make[1]: *** [kernel/sched.o] Error 1
make: *** [kernel] Error 2

'calc_delta_weight' or a replacement not found easily to fix it up!

Thanks

Parag
