Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbXKEX3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbXKEX3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 18:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbXKEX3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 18:29:38 -0500
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:33367 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752554AbXKEX3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 18:29:37 -0500
X-Greylist: delayed 4208 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Nov 2007 18:29:37 EST
Date: Mon, 5 Nov 2007 23:19:25 +0100 (CET)
From: Peter Osterlund <petero2@telia.com>
X-X-Sender: petero@quad.localdomain
To: Jens Axboe <jens.axboe@oracle.com>, Tejun Heo <htejun@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Maier <balagi@justmail.de>
Subject: Re: pktcdvd oops
In-Reply-To: <20071105092018.GD5359@kernel.dk>
Message-ID: <Pine.LNX.4.64.0711052312410.5445@quad.localdomain>
References: <20071105092018.GD5359@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2007, Jens Axboe wrote:

> Hi Peter,
>
> You don't seem to have a bugzilla account, so could not reassign to you.
> See http://bugzilla.kernel.org/show_bug.cgi?id=9294

Problem is repeatable on my computer. It dies in __module_get() on this 
line:

 		BUG_ON(module_refcount(module) == 0);

I think this is because commit 7b595756ec1f49e0049a9e01a1298d53a7faaa15, 
which states: "Note that with this change, userland holding a sysfs node 
does not prevent the backing module from being unloaded."

Unfortunately, I don't know how this sysfs stuff is supposed to work, and 
therefore don't know how to fix the problem.

-- 
Peter Osterlund - petero2@telia.com
http://web.telia.com/~u89404340
