Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbXJAUt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbXJAUt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 16:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbXJAUtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 16:49:50 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60086 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbXJAUtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 16:49:49 -0400
Date: Mon, 1 Oct 2007 22:49:48 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: casey@schaufler-ca.com, torvalds@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, James Morris <jmorris@namei.org>,
       Paul Moore <paul.moore@hp.com>
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access
 Control Kernel
In-Reply-To: <20070930011618.ccb8351b.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0710012240270.7130@fbirervta.pbzchgretzou.qr>
References: <46FEEBD4.5050401@schaufler-ca.com> <20070930011618.ccb8351b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 30 2007 01:16, Andrew Morton wrote:
>> 
>>  Documentation/Smack.txt       |  104 +
>>  security/Kconfig              |    1 
>>  security/Makefile             |    2 
>>  security/smack/Kconfig        |   10 
>>  security/smack/Makefile       |    9 
>>  security/smack/smack.h        |  207 ++
>>  security/smack/smack_access.c |  345 ++++
>>  security/smack/smack_lsm.c    | 2685 ++++++++++++++++++++++++++++++++
>>  security/smack/smackfs.c      | 1201 ++++++++++++++
>>  9 files changed, 4564 insertions(+)
>
>My major non-technical concern is that Casey Schaufler might get hit by a
>bus.  If this happens, we can remove the feature in three minutes (that
>diffstat again), but that may not be feasible if people have come to rely
>upon the feature.
>
>otoh, if a significant number of people are using smack, presumably someone
>else would step up to maintain smack post-bus.  The risk seems acceptable
>to me.

I bet that the number of people submitting patches / possibly maintaining it
is hyperbelic to the code size. Everyone that runs away from selinux's
code size and/or "complexity" is a potential smack/aa user/contributor.

>Is smack useful without a patched ls, sshd and init.d?  What is the status
>of getting those userspace patches merged?  ie: do you know who to send the
>diffs to, and are they likely to take them?

As long as one does not need to recompile userspace (like it is the case with
libselinux), it wins.
