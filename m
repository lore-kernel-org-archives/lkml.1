Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbZI3QQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbZI3QQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 12:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbZI3QQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 12:16:54 -0400
Received: from mtagate4.de.ibm.com ([195.212.17.164]:50269 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbZI3QQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 12:16:53 -0400
Message-ID: <4AC38477.4070007@free.fr>
Date: Wed, 30 Sep 2009 18:16:55 +0200
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Dan Smith <danms@us.ibm.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, mingo@elte.hu, xemul@openvz.org
Subject: Re: [PATCH 00/80] Kernel based checkpoint/restart [v18]
References: <1253749920-18673-1-git-send-email-orenl@librato.com>	<20090924154139.2a7dd5ec.akpm@linux-foundation.org>	<20090928163704.GA3327@us.ibm.com> <4AC20BB8.4070509@free.fr> <87iqf0o5sf.fsf@caffeine.danplanet.com>
In-Reply-To: <87iqf0o5sf.fsf@caffeine.danplanet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Smith wrote:
> DL> Ok for the restart, but for the checkpoint, how do you access the
> DL> network setup from a process which belongs to another namespace
> DL> context ?
>
> So far the discussion has led to the kernel dumping all of that
> information on checkpoint, and then splitting it up into what can be
> done by userspace on restart and what still needs to be in the kernel.
>   
Ah, this was a discussion in the containers@ mailing list ?
Sorry I missed it, I will look at the containers@ archives.

If the checkpoint is done from the kernel, why the restart wouldn't be 
in the kernel too ?
Do you have a list of what is restartable from userspace or from the 
kernel ?

Is there any documentation about the statefile format I can use if I 
want to implement myself an userspace CR solution based on this kernel 
patchset ?
> Similarly, the task structure is currently exported by the kernel on
> checkpoint, but recreated in userspace on restart.
>   
(I guess you meant tasks hierarchy/tree) Well I understand why this is 
done from userspace but I don't like the idea of digging in the 
statefile, but there's no accounting for taste :)

