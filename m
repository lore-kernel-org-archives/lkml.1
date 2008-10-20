Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbYJTWdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbYJTWdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 18:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbYJTWdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 18:33:25 -0400
Received: from mail.lang.hm ([64.81.33.126]:45634 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbYJTWdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 18:33:24 -0400
Date: Mon, 20 Oct 2008 15:34:07 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: sched_yield() options
Message-ID: <alpine.DEB.1.10.0810201531010.21749@asgard.lang.hm>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've seen a lot of discussion about how sched_yield is abused by 
applications. I'm working with a developer on one application that looks 
like it's falling into this same trap (mutexes between threads and using 
sched_yield (or more precisely pthread_yield()) to let other threads get 
the lock)

however I've been having a hard time tracking down the appropriate 
discussions to forward on to the developer (both for why what he's doing 
is bad, and for what he should be doing instead)

could someone point out appropriate mailing list threads, or other 
documentation for this?

David Lang
