Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbYGPKHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbYGPKHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 06:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbYGPKGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 06:06:52 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:55125 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbYGPKGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 06:06:52 -0400
Date: Wed, 16 Jul 2008 12:06:51 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Bodo Eggert <7eggert@gmx.de>
cc: jkacur@gmail.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Make the git URL match usage
In-Reply-To: <E1KJ3Ex-0001LD-Ub@be1.7eggert.dyndns.org>
Message-ID: <alpine.LNX.1.10.0807161205220.26724@fbirervta.pbzchgretzou.qr>
References: <aQ9CN-4cK-11@gated-at.bofh.it> <E1KJ3Ex-0001LD-Ub@be1.7eggert.dyndns.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 2008-07-16 10:54, Bodo Eggert wrote:

>jkacur <jkacur@gmail.com> wrote:
>
>> Subject: Make the git URL match the usage
>> Change the MAINTAINERS file so that the git URL reads EXACTLY the way someone
>> would use it.
>
>> +++ linux-2.6.26/MAINTAINERS 
>
>> +T:   git://git.kernel.org:/pub/scm/linux/kernel/ericvh/v9fs.git
>                            ^^

There is more brokenness in this patch. That URL (even without ':')
gives 404.
Here is a clueful hint...

-git://git.kernel.org/pub/scm/linux/kernel/ericvh/v9fs.git
+git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git

Check the URLs before modifying them.
