Return-Path: <linux-kernel-owner+w=401wt.eu-S1761095AbZANI6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761095AbZANI6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 03:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756922AbZANI6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 03:58:38 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:62939 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736AbZANI6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 03:58:37 -0500
Message-Id: <200901140857.n0E8vwbg098948@www262.sakura.ne.jp>
Subject: Re: [TOMOYO #14 (mmotm 2008-12-30-16-05) 02/10] Singly linked list implementation.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: jmorris@namei.org
Cc: akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 14 Jan 2009 17:57:58 +0900
References: <20090101050741.372438529@I-love.SAKURA.ne.jp> <20090101050939.802554261@I-love.SAKURA.ne.jp> <alpine.LRH.1.10.0901051926130.16049@tundra.namei.org>
In-Reply-To: <alpine.LRH.1.10.0901051926130.16049@tundra.namei.org>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 14012009 #1451940, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> > By ommiting pointer to previous element, the reader becomes read lock free,
> > which is good thing for implementing "write once read many" list.
> 
> This has a technical ack from Paul, but what about Linus' long-standing 
> objection to singly-linked lists in the kernel?  I'm sure this has been 
> discussed re. your patches, but I can't find a reference.
> 
OK, for reviewers' ease, I purged list1 for now.

Next posting (#15) will use standard doubly linked list with rw_semaphore.

Thanks.
